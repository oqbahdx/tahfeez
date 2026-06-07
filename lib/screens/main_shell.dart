import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../core/constants/api_constants.dart';
import '../core/di/injection_container.dart' as di;
import '../core/network/api_client.dart';
import '../features/class/presentation/blocs/class_bloc.dart';
import '../features/class/presentation/pages/classes_screen.dart';
import '../features/student/presentation/blocs/student_bloc.dart';
import '../features/student/presentation/blocs/student_event.dart';
import '../features/recitation/presentation/blocs/recitation_bloc.dart';
import '../features/attendance/presentation/bloc/attendance_bloc.dart';
import '../l10n/app_localizations.dart';
import '../widgets/shared_widgets.dart';
import 'dashboard_screen.dart';
import 'students_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  final Function(Locale)? onLocaleChange;

  const MainShell({super.key, this.onLocaleChange});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 1;
  bool _canAccessStudents = true;

  @override
  void initState() {
    super.initState();
    _initRole();
  }

  Future<void> _initRole() async {
    try {
      final apiClient = di.sl<ApiClient>();
      final token = await apiClient.getAccessToken();
      if (token != null && !JwtDecoder.isExpired(token)) {
        final claims = JwtDecoder.decode(token);
        final role = claims['role'] as String?;
        if (mounted) {
          setState(() {
            _canAccessStudents = role == RoleConstants.admin ||
                role == RoleConstants.teacher;
          });
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 768;
    final l10n = AppLocalizations.of(context)!;

    final tabs = <NavItemData>[
      NavItemData(Icons.dashboard_outlined, l10n.dashboard),
      NavItemData(Icons.school_outlined, l10n.classes),
      if (_canAccessStudents)
        NavItemData(Icons.people_outline, l10n.students),
      NavItemData(Icons.analytics_outlined, l10n.reports),
      NavItemData(Icons.settings_outlined, l10n.settings),
    ];

    if (_currentIndex >= tabs.length) {
      _currentIndex = tabs.length - 1;
    }

    return BlocProvider<ClassBloc>(
      create: (_) => di.sl<ClassBloc>(),
      child: BlocProvider<RecitationBloc>(
        create: (_) => di.sl<RecitationBloc>(),
        child: BlocProvider<StudentBloc>(
          create: (_) => di.sl<StudentBloc>()..add(GetStudentsEvent()),
          child: BlocProvider<AttendanceBloc>(
            create: (_) => di.sl<AttendanceBloc>(),
            child: Scaffold(
              drawer: isWide
                  ? null
                  : TahfeezDrawer(
                      currentIndex: _currentIndex,
                      onTap: (i) {
                        setState(() => _currentIndex = i);
                        Navigator.pop(context);
                      },
                      items: tabs,
                    ),
              body: isWide
                  ? Row(
                      children: [
                        SizedBox(
                          width: 320,
                          child: TahfeezDrawer(
                            currentIndex: _currentIndex,
                            onTap: (i) => setState(() => _currentIndex = i),
                            items: tabs,
                          ),
                        ),
                        Expanded(child: _buildBody(tabs)),
                      ],
                    )
                  : _buildBody(tabs),
              bottomNavigationBar: isWide
                  ? null
                  : TahfeezBottomNav(
                      currentIndex:
                          _currentIndex > 0 ? _currentIndex - 1 : 0,
                      onTap: (i) => setState(() => _currentIndex = i + 1),
                      items: tabs.length > 1 ? tabs.sublist(1) : null,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(List<NavItemData> tabs) {
    return IndexedStack(
      index: _currentIndex,
      children: [
        DashboardScreen(onLocaleChange: widget.onLocaleChange),
        const ClassesScreen(),
        if (_canAccessStudents) const StudentsScreen(),
        const ReportsScreen(),
        SettingsScreen(onLocaleChange: widget.onLocaleChange),
      ],
    );
  }
}

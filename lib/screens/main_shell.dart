import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/injection_container.dart' as di;
import '../features/class/presentation/blocs/class_bloc.dart';
import '../features/class/presentation/pages/classes_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 768;

    return BlocProvider<ClassBloc>(
      create: (_) => di.sl<ClassBloc>(),
      child: Scaffold(
        drawer: isWide
            ? null
            : TahfeezDrawer(
                currentIndex: _currentIndex,
                onTap: (i) {
                  setState(() => _currentIndex = i);
                  Navigator.pop(context);
                },
              ),
        body: isWide
            ? Row(
                children: [
                  SizedBox(
                    width: 320,
                    child: TahfeezDrawer(
                      currentIndex: _currentIndex,
                      onTap: (i) => setState(() => _currentIndex = i),
                    ),
                  ),
                  Expanded(child: _buildCurrentScreen()),
                ],
              )
            : _buildCurrentScreen(),
        bottomNavigationBar: isWide
            ? null
            : TahfeezBottomNav(
                currentIndex: _currentIndex > 0 ? _currentIndex - 1 : 0,
                onTap: (i) => setState(() => _currentIndex = i + 1),
              ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return DashboardScreen(onLocaleChange: widget.onLocaleChange);
      case 1:
        return const ClassesScreen();
      case 2:
        return const StudentsScreen();
      case 3:
        return const ReportsScreen();
      case 4:
        return SettingsScreen(onLocaleChange: widget.onLocaleChange);
      default:
        return const ClassesScreen();
    }
  }
}

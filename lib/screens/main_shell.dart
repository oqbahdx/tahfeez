import 'package:flutter/material.dart';
import '../widgets/shared_widgets.dart';
import 'dashboard_screen.dart';
import 'classes_screen.dart';
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
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    DashboardScreen(onLocaleChange: widget.onLocaleChange),
    const ClassesScreen(),
    const StudentsScreen(),
    const ReportsScreen(),
    SettingsScreen(onLocaleChange: widget.onLocaleChange),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
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
                Expanded(child: _screens[_currentIndex]),
              ],
            )
          : _screens[_currentIndex],
      bottomNavigationBar: isWide
          ? null
          : TahfeezBottomNav(
              currentIndex: _currentIndex > 0 ? _currentIndex - 1 : 0,
              onTap: (i) => setState(() => _currentIndex = i + 1),
            ),
    );
  }
}

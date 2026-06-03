import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'l10n/app_localizations.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/presentation/blocs/auth_event.dart';
import 'features/auth/presentation/blocs/auth_state.dart';
import 'features/class/presentation/blocs/class_bloc.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Locale _locale = const Locale('ar');
  bool _showRegister = false;

  void _onLocaleChange(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthBloc>()..add(CheckAuthEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tahfeez',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF004647)),
          useMaterial3: true,
        ),
        locale: _locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return BlocProvider(
                create: (_) => di.sl<ClassBloc>(),
                child: MainShell(onLocaleChange: _onLocaleChange),
              );
            }
            if (_showRegister) {
              return RegisterScreen(
                onLoginTap: () => setState(() => _showRegister = false),
              );
            }
            return LoginScreen(
              onLocaleChange: _onLocaleChange,
              onRegisterTap: () => setState(() => _showRegister = true),
            );
          },
        ),
      ),
    );
  }
}

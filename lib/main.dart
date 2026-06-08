import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/auth/auth_service.dart';
import 'core/di/injection_container.dart' as di;
import 'l10n/app_localizations.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/presentation/blocs/auth_event.dart';
import 'features/auth/presentation/blocs/auth_state.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  final prefs = await SharedPreferences.getInstance();
  final savedRole = prefs.getString('role');
  if (savedRole != null) {
    di.sl<AuthService>().setRole(savedRole);
  }
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
        home: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              current is AuthAuthenticated || current is AuthUnauthenticated,
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              di.sl<AuthService>().setRole(state.role);
            } else if (state is AuthUnauthenticated) {
              di.sl<AuthService>().clear();
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSplash || state is AuthInitial) {
                return const SplashScreen();
              }
              if (state is AuthAuthenticated) {
                return MainShell(onLocaleChange: _onLocaleChange);
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
      ),
    );
  }
}

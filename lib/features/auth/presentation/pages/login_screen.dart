import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../screens/main_shell.dart';
import '../../presentation/blocs/auth_bloc.dart';
import '../../presentation/blocs/auth_event.dart';
import '../../presentation/blocs/auth_state.dart';

class LoginScreen extends StatefulWidget {
  final Function(Locale)? onLocaleChange;
  final VoidCallback? onRegisterTap;

  const LoginScreen({super.key, this.onLocaleChange, this.onRegisterTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Validation error messages
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    String? emailErr;
    String? passwordErr;

    if (email.isEmpty) {
      emailErr = AppLocalizations.of(context)?.emailAddress != null
          ? 'Email is required'
          : 'Email is required';
    } else if (!RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      emailErr = 'Enter a valid email address';
    }

    if (password.isEmpty) {
      passwordErr = 'Password is required';
    } else if (password.length < 6) {
      passwordErr = AppLocalizations.of(context)?.passwordTooShort ?? 'Password too short';
    }

    setState(() {
      _emailError = emailErr;
      _passwordError = passwordErr;
    });

    return emailErr == null && passwordErr == null;
  }

  void _signIn() {
    if (!_validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    context.read<AuthBloc>().add(LoginEvent(email: email, password: password));
  }

  void _toggleLanguage() {
    final currentLocale = Localizations.localeOf(context);
    final newLocale = currentLocale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    widget.onLocaleChange?.call(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final currentLocale = Localizations.localeOf(context);
    final isArabic = currentLocale.languageCode == 'ar';

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MainShell(onLocaleChange: widget.onLocaleChange),
            ),
          );
        } else if (state is AuthError) {
          AppToast.error(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          backgroundColor: TahfeezColors.background,
          body: Stack(
            children: [
              Positioned(
                top: 16,
                right: isArabic ? null : 16,
                left: isArabic ? 16 : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: TahfeezColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: TahfeezColors.outlineVariant),
                      ),
                      child: TextButton.icon(
                        onPressed: _toggleLanguage,
                        icon: const Icon(
                          Icons.language,
                          color: TahfeezColors.primary,
                          size: 18,
                        ),
                        label: Text(
                          isArabic ? 'English' : 'العربية',
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: TahfeezColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -100,
                top: -100,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        TahfeezColors.primaryContainer.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: -80,
                bottom: -80,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        TahfeezColors.secondaryContainer.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    height: isWide ? 600 : null,
                    decoration: BoxDecoration(
                      color: TahfeezColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: TahfeezColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    child: isWide
                        ? Row(
                            children: [
                              _buildLeftPanel(),
                              Expanded(child: _buildFormPanel(isLoading: isLoading)),
                            ],
                          )
                        : _buildFormPanel(isLoading: isLoading),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeftPanel() {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
        child: Stack(
          children: [
            Container(color: TahfeezColors.primary),
            Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: TahfeezColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_stories,
                      color: TahfeezColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'تحفيظ\nTahfeez',
                    style: GoogleFonts.lexend(
                      fontSize: 48,
                      fontWeight: FontWeight.w400,
                      color: TahfeezColors.onPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sacred tradition meets modern management. Streamlining Quranic education for institutions.',
                    style: TahfeezTextStyles.bodyLg.copyWith(
                      color: TahfeezColors.primaryFixedDim,
                    ),
                    maxLines: 3,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TahfeezColors.primary.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: TahfeezColors.primaryFixed.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.security,
                          color: TahfeezColors.secondaryContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Secure access for administrators, teachers, and staff.',
                            style: TahfeezTextStyles.labelMd.copyWith(
                              color: TahfeezColors.primaryFixed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormPanel({bool isLoading = false}) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n?.welcomeBack ?? '',
            style: TahfeezTextStyles.headlineLg.copyWith(
              color: TahfeezColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.pleaseSignIn ?? '',
            style: TahfeezTextStyles.bodyMd.copyWith(
              color: TahfeezColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n?.emailAddress ?? '',
            style: TahfeezTextStyles.labelMd.copyWith(
              color: TahfeezColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !isLoading,
            onChanged: (_) {
              if (_emailError != null) setState(() => _emailError = null);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.mail_outlined,
                color: TahfeezColors.outline,
              ),
              hintText: 'admin@institute.edu',
              errorText: _emailError,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n?.password ?? '',
                style: TahfeezTextStyles.labelMd.copyWith(
                  color: TahfeezColors.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: Text(
                  l10n?.forgotPassword ?? '',
                  style: TahfeezTextStyles.labelMd.copyWith(
                    color: TahfeezColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            enabled: !isLoading,
            onChanged: (_) {
              if (_passwordError != null) setState(() => _passwordError = null);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock_outlined,
                color: TahfeezColors.outline,
              ),
              hintText: '••••••••',
              errorText: _passwordError,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: TahfeezColors.outline,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: isLoading ? null : _signIn,
            style: FilledButton.styleFrom(
              backgroundColor: TahfeezColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
            ),
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TahfeezColors.onPrimary,
                    ),
                  )
                : const SizedBox.shrink(),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n?.signIn ?? '',
                  style: TahfeezTextStyles.labelLg.copyWith(
                    color: TahfeezColors.onPrimary,
                  ),
                ),
                if (!isLoading) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: TahfeezColors.onPrimary,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text.rich(
            TextSpan(
              text: '${l10n?.alreadyHaveAccount ?? ''} ',
              style: TahfeezTextStyles.bodyMd.copyWith(
                color: TahfeezColors.onSurfaceVariant,
              ),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: GestureDetector(
                    onTap: widget.onRegisterTap,
                    child: Text(
                      l10n?.createNewAccount ?? '',
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: TahfeezColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

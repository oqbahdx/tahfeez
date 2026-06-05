import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import '../../l10n/app_localizations.dart';
import '../../core/constants/api_constants.dart';
import '../../core/di/injection_container.dart';
import '../../core/utils/toast_helper.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../features/auth/presentation/blocs/auth_event.dart';
import '../../features/auth/presentation/blocs/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onLoginTap;

  const RegisterScreen({super.key, required this.onLoginTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = RoleConstants.admin;
  String _passwordValue = '';

  // Field-level validation errors
  String? _userNameError;
  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Password rules
  bool get _hasMinLength => _passwordValue.length >= 8;
  bool get _hasUppercase => _passwordValue.contains(RegExp(r'[A-Z]'));
  bool get _hasLowercase => _passwordValue.contains(RegExp(r'[a-z]'));
  bool get _hasSpecial =>
      _passwordValue.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\\/]'));
  bool get _passwordValid =>
      _hasMinLength && _hasUppercase && _hasLowercase && _hasSpecial;

  static int _roleToInt(String role) {
    switch (role) {
      case RoleConstants.admin:
        return 1;
      case RoleConstants.teacher:
        return 2;
      case RoleConstants.student:
        return 3;
      case RoleConstants.parent:
        return 4;
      case RoleConstants.accountant:
        return 5;
      case RoleConstants.supervisor:
        return 6;
      case RoleConstants.assistant:
        return 7;
      default:
        return 1;
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate(AppLocalizations l10n) {
    String? userNameErr;
    String? fullNameErr;
    String? emailErr;
    String? passwordErr;
    String? confirmPasswordErr;

    final userName = _userNameController.text.trim();
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (userName.isEmpty) {
      userNameErr = l10n.usernameRequired;
    } else if (userName.length < 3) {
      userNameErr = l10n.usernameMinLength;
    } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(userName)) {
      userNameErr = l10n.usernameInvalidChars;
    }

    if (fullName.isEmpty) {
      fullNameErr = l10n.fullNameRequired;
    } else if (fullName.length < 2) {
      fullNameErr = l10n.fullNameMinLength;
    }

    if (email.isEmpty) {
      emailErr = l10n.emailRequired;
    } else if (!RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      emailErr = l10n.invalidEmail;
    }

    if (password.isEmpty) {
      passwordErr = l10n.passwordRequired;
    } else if (!_passwordValid) {
      passwordErr = l10n.passwordComplexity;
    }

    if (confirmPassword.isEmpty) {
      confirmPasswordErr = l10n.confirmPasswordRequired;
    } else if (password != confirmPassword) {
      confirmPasswordErr = l10n.passwordsDoNotMatch;
    }

    setState(() {
      _userNameError = userNameErr;
      _fullNameError = fullNameErr;
      _emailError = emailErr;
      _passwordError = passwordErr;
      _confirmPasswordError = confirmPasswordErr;
    });

    return userNameErr == null &&
        fullNameErr == null &&
        emailErr == null &&
        passwordErr == null &&
        confirmPasswordErr == null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWide = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f8),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (isWide) _buildBrandingPanel(context),
              Expanded(
                child: BlocProvider(
                  create: (_) => sl<AuthBloc>(),
                  child: _buildRegisterForm(context, l10n),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBrandingPanel(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1b5e60),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFF004647)),
            ),
          ),
          CustomPaint(painter: _GeometricPatternPainter()),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_stories,
                        color: Color(0xFF004647),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'تحفيظ',
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 57,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Tahfeez',
                      style: TextStyle(
                        fontFamily: 'Lexend',
                        fontSize: 57,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context, AppLocalizations l10n) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthUnauthenticated) {
          AppToast.success(l10n.registrationSuccessful);
          widget.onLoginTap();
        } else if (state is AuthError) {
          AppToast.error(state.message);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (ctx, state) {
          final isLoading = state is AuthLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.createAccount,
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1c1c),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.joinInstitution,
                  style: const TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 14,
                    color: Color(0xFF3f4849),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  l10n.username,
                  _userNameController,
                  Icons.person_outline,
                  errorText: _userNameError,
                  onChanged: (_) {
                    if (_userNameError != null) {
                      setState(() => _userNameError = null);
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  l10n.fullName,
                  _fullNameController,
                  Icons.badge_outlined,
                  errorText: _fullNameError,
                  onChanged: (_) {
                    if (_fullNameError != null) {
                      setState(() => _fullNameError = null);
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  l10n.emailAddress,
                  _emailController,
                  Icons.mail_outline,
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    if (_emailError != null) {
                      setState(() => _emailError = null);
                    }
                  },
                ),
                const SizedBox(height: 16),
                _buildDropdown(l10n),
                const SizedBox(height: 16),
                _buildPasswordField(
                  l10n.password,
                  _passwordController,
                  _obscurePassword,
                  () => setState(() => _obscurePassword = !_obscurePassword),
                  errorText: _passwordError,
                  onChanged: (v) {
                    setState(() {
                      _passwordValue = v;
                      if (_passwordError != null) _passwordError = null;
                    });
                  },
                ),
                if (_passwordValue.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildPasswordStrengthHints(l10n),
                ],
                const SizedBox(height: 16),
                _buildPasswordField(
                  l10n.confirmPassword,
                  _confirmPasswordController,
                  _obscureConfirmPassword,
                  () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                  errorText: _confirmPasswordError,
                  onChanged: (_) {
                    if (_confirmPasswordError != null) {
                      setState(() => _confirmPasswordError = null);
                    }
                  },
                ),
                const SizedBox(height: 24),
                _buildSubmitButton(ctx, l10n, isLoading),
                const SizedBox(height: 32),
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: '${l10n.alreadyHaveAccount} ',
                      children: [
                        TextSpan(
                          text: l10n.signIn,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF004647),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onLoginTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? errorText,
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6f7979)),
        errorText: errorText,
        filled: true,
        fillColor: const Color(0xFFf9f9f8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6f7979)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF755b00), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD32F2F)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscure,
    VoidCallback onToggle, {
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6f7979)),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF6f7979),
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFFf9f9f8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6f7979)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF755b00), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD32F2F)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthHints(AppLocalizations l10n) {
    final metCount =
        [_hasMinLength, _hasUppercase, _hasLowercase, _hasSpecial]
            .where((r) => r)
            .length;

    Color barColor() {
      if (metCount <= 1) return const Color(0xFFe53935);
      if (metCount == 2) return const Color(0xFFfb8c00);
      if (metCount == 3) return const Color(0xFFfdd835);
      return const Color(0xFF43a047);
    }

    String strengthLabel() {
      if (metCount <= 1) return l10n.passwordStrengthWeak;
      if (metCount == 2) return l10n.passwordStrengthFair;
      if (metCount == 3) return l10n.passwordStrengthGood;
      return l10n.passwordStrengthStrong;
    }

    final color = barColor();
    final label = strengthLabel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: List.generate(4, (i) {
                  final filled = i < metCount;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 4,
                      margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: filled ? color : const Color(0xFFdde3e3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                label,
                key: ValueKey(label),
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildRuleRow(
          _buildRuleChip(_hasMinLength, l10n.passwordRuleMinLength),
          _buildRuleChip(_hasUppercase, l10n.passwordRuleUppercase),
        ),
        const SizedBox(height: 6),
        _buildRuleRow(
          _buildRuleChip(_hasLowercase, l10n.passwordRuleLowercase),
          _buildRuleChip(_hasSpecial, l10n.passwordRuleSpecialChar),
        ),
      ],
    );
  }

  Widget _buildRuleRow(Widget a, Widget b) {
    return Row(
      children: [
        Expanded(child: a),
        const SizedBox(width: 8),
        Expanded(child: b),
      ],
    );
  }

  Widget _buildRuleChip(bool met, String label) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: met ? const Color(0xFFe8f5e9) : const Color(0xFFf5f5f5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: met ? const Color(0xFF43a047) : const Color(0xFFd0d8d8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              met ? Icons.check_circle_rounded : Icons.circle_outlined,
              key: ValueKey(met),
              size: 13,
              color: met ? const Color(0xFF43a047) : const Color(0xFF9e9e9e),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w500,
              color: met ? const Color(0xFF2e7d32) : const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleLabel(String role, AppLocalizations l10n) {
    switch (role) {
      case RoleConstants.admin:
        return l10n.roleAdmin;
      case RoleConstants.teacher:
        return l10n.roleTeacher;
      case RoleConstants.student:
        return l10n.roleStudent;
      case RoleConstants.parent:
        return l10n.roleParent;
      case RoleConstants.accountant:
        return l10n.roleAccountant;
      case RoleConstants.supervisor:
        return l10n.roleSupervisor;
      case RoleConstants.assistant:
        return l10n.roleAssistant;
      default:
        return role;
    }
  }

  Widget _buildDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedRole,
      decoration: InputDecoration(
        labelText: l10n.selectRole,
        prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF6f7979)),
        filled: true,
        fillColor: const Color(0xFFf9f9f8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF6f7979)),
        ),
      ),
      items: RoleConstants.allRoles
          .map(
            (r) => DropdownMenuItem(
              value: r,
              child: Text(_getRoleLabel(r, l10n)),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => _selectedRole = v);
      },
    );
  }

  void _submit(BuildContext ctx, AppLocalizations l10n) {
    if (!_validate(l10n)) return;

    ctx.read<AuthBloc>().add(
      RegisterEvent(
        userName: _userNameController.text.trim(),
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        role: _roleToInt(_selectedRole),
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext ctx,
    AppLocalizations l10n,
    bool isLoading,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _submit(ctx, l10n),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF004647),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.createAccount,
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
      ),
    );
  }
}

class _GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;
    for (var x = 0.0; x < size.width; x += 24.0) {
      for (var y = 0.0; y < size.height; y += 24.0) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

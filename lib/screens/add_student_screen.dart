import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../core/utils/toast_helper.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';
import '../features/auth/domain/usecases/auth_usecases.dart';
import '../features/auth/domain/enums/user_role.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final l10n = AppLocalizations.of(context)!;
    final useCase = GetIt.instance<RegisterUseCase>();

    final result = await useCase(
      userName: _userNameController.text.trim(),
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      role: UserRole.student.value,
    );

    setState(() => _isSubmitting = false);

    result.fold(
      (failure) {
        if (!mounted) return;
        AppToast.error(failure.message);
      },
      (_) {
        if (!mounted) return;
        AppToast.success(l10n.studentCreated);
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: TahfeezColors.background,
      appBar: AppBar(
        backgroundColor: TahfeezColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: TahfeezColors.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: TahfeezColors.surfaceContainer,
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => Navigator.of(context).pop(false),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: TahfeezColors.onSurface,
              ),
            ),
          ),
        ),
        title: Text(
          l10n.addStudent,
          style: TahfeezTextStyles.headlineLg.copyWith(
            color: TahfeezColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TahfeezColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: TahfeezColors.primary.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: TahfeezColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_add_outlined,
                        color: TahfeezColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.addStudent,
                            style: TahfeezTextStyles.titleLg.copyWith(
                              color: TahfeezColors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.joinInstitution,
                            style: TahfeezTextStyles.bodyMd.copyWith(
                              color: TahfeezColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  color: TahfeezColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: TahfeezColors.surfaceContainer,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: TahfeezColors.onSurface.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFormSection(
                      icon: Icons.person_outline,
                      title: l10n.username,
                      isFirst: true,
                      child: TextFormField(
                        controller: _userNameController,
                        style: TahfeezTextStyles.bodyMd.copyWith(
                          color: TahfeezColors.onSurface,
                        ),
                        decoration: _inputDecoration(hintText: null),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l10n.usernameRequired;
                          }
                          if (v.contains(' ')) {
                            return l10n.usernameInvalidChars;
                          }
                          if (v.trim().length < 3) {
                            return l10n.usernameMinLength;
                          }
                          return null;
                        },
                      ),
                    ),

                    _buildDivider(),

                    _buildFormSection(
                      icon: Icons.badge_outlined,
                      title: l10n.fullName,
                      child: TextFormField(
                        controller: _fullNameController,
                        style: TahfeezTextStyles.bodyMd.copyWith(
                          color: TahfeezColors.onSurface,
                        ),
                        decoration: _inputDecoration(hintText: null),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l10n.fullNameRequired;
                          }
                          if (v.trim().length < 2) {
                            return l10n.fullNameMinLength;
                          }
                          return null;
                        },
                      ),
                    ),

                    _buildDivider(),

                    _buildFormSection(
                      icon: Icons.email_outlined,
                      title: l10n.emailAddress,
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TahfeezTextStyles.bodyMd.copyWith(
                          color: TahfeezColors.onSurface,
                        ),
                        decoration: _inputDecoration(hintText: null),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return l10n.emailRequired;
                          }
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegex.hasMatch(v.trim())) {
                            return l10n.invalidEmail;
                          }
                          return null;
                        },
                      ),
                    ),

                    _buildDivider(),

                    _buildFormSection(
                      icon: Icons.lock_outline,
                      title: l10n.password,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TahfeezTextStyles.bodyMd.copyWith(
                          color: TahfeezColors.onSurface,
                        ),
                        decoration: _inputDecoration(
                          hintText: null,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: TahfeezColors.onSurfaceVariant,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return l10n.passwordRequired;
                          }
                          if (v.length < 8) {
                            return l10n.passwordTooShort;
                          }
                          return null;
                        },
                      ),
                    ),

                    _buildDivider(),

                    _buildFormSection(
                      icon: Icons.lock_outline,
                      title: l10n.confirmPassword,
                      isLast: true,
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        style: TahfeezTextStyles.bodyMd.copyWith(
                          color: TahfeezColors.onSurface,
                        ),
                        decoration: _inputDecoration(
                          hintText: null,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: TahfeezColors.onSurfaceVariant,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return l10n.confirmPasswordRequired;
                          }
                          if (v != _passwordController.text) {
                            return l10n.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: TahfeezColors.primary,
                  disabledBackgroundColor:
                      TahfeezColors.primary.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: TahfeezColors.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l10n.submitting,
                            style: TahfeezTextStyles.labelLg.copyWith(
                              color: TahfeezColors.onPrimary,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            size: 18,
                            color: TahfeezColors.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.submit,
                            style: TahfeezTextStyles.labelLg.copyWith(
                              color: TahfeezColors.onPrimary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required IconData icon,
    required String title,
    required Widget child,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        isFirst ? 20 : 16,
        16,
        isLast ? 20 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: TahfeezColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: TahfeezColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TahfeezTextStyles.titleLg.copyWith(
                  color: TahfeezColors.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: TahfeezColors.surfaceContainer,
      ),
    );
  }

  InputDecoration _inputDecoration({
    Widget? suffixIcon,
    String? hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      hintStyle: TahfeezTextStyles.bodyMd.copyWith(
        color: TahfeezColors.onSurfaceVariant,
      ),
      filled: true,
      fillColor: TahfeezColors.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: TahfeezColors.surfaceContainer,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: TahfeezColors.surfaceContainer,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: TahfeezColors.primary.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: TahfeezColors.error.withOpacity(0.6),
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: TahfeezColors.error,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
    );
  }
}

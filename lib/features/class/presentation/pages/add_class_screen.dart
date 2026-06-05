import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/enums/class_type.dart';
import '../../domain/enums/class_mode.dart';
import '../blocs/class_bloc.dart';
import '../blocs/class_event.dart';
import '../blocs/class_state.dart';

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({super.key});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  ClassType? _selectedType;
  ClassMode? _selectedMode;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    if (_selectedType == null || _selectedMode == null) return;

    context.read<ClassBloc>().add(CreateClassEvent(
          name: name,
          type: _selectedType!.value,
          mode: _selectedMode!.value,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ClassBloc, ClassState>(
      listenWhen: (previous, current) =>
          current is ClassOperationSuccess || current is ClassError,
      listener: (context, state) {
        if (state is ClassOperationSuccess) {
          AppToast.success(l10n.classCreated);
          Navigator.of(context).pop();
        } else if (state is ClassError) {
          AppToast.error(state.message);
        }
      },
      builder: (context, state) {
        final isSubmitting = state is ClassOperationLoading;

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
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: TahfeezColors.onSurface,
                  ),
                ),
              ),
            ),
            title: Text(
              l10n.addClassTitle,
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
                  // Intro card
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
                            Icons.menu_book_rounded,
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
                                l10n.addClassTitle,
                                style: TahfeezTextStyles.titleLg.copyWith(
                                  color: TahfeezColors.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.addClassSubtitle,
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

                  // Form card
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
                        // Class Name Field
                        _buildFormSection(
                          icon: Icons.drive_file_rename_outline_rounded,
                          title: l10n.className,
                          isFirst: true,
                          child: TextFormField(
                            controller: _nameController,
                            style: TahfeezTextStyles.bodyMd.copyWith(
                              color: TahfeezColors.onSurface,
                            ),
                            decoration: _inputDecoration(
                              hintText: l10n.classNameHint,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.nameRequired;
                              }
                              if (value.trim().length > 100) {
                                return l10n.classNameTooLong;
                              }
                              return null;
                            },
                          ),
                        ),

                        _buildDivider(),

                        // Class Type Field
                        _buildFormSection(
                          icon: Icons.category_outlined,
                          title: l10n.classType,
                          child: DropdownButtonFormField<ClassType>(
                            value: _selectedType,
                            decoration: _inputDecoration(hintText: null),
                            hint: Text(
                              l10n.classTypePlaceholder,
                              style: TahfeezTextStyles.bodyMd.copyWith(
                                color: TahfeezColors.onSurfaceVariant,
                              ),
                            ),
                            items: ClassType.values
                                .map((type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(
                                        type.displayName,
                                        style:
                                            TahfeezTextStyles.bodyMd.copyWith(
                                          color: TahfeezColors.onSurface,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _selectedType = v),
                            validator: (v) =>
                                v == null ? l10n.typeRequired : null,
                          ),
                        ),

                        _buildDivider(),

                        // Class Mode Field
                        _buildFormSection(
                          icon: Icons.toggle_on_outlined,
                          title: l10n.classMode,
                          isLast: true,
                          child: DropdownButtonFormField<ClassMode>(
                            value: _selectedMode,
                            decoration: _inputDecoration(hintText: null),
                            hint: Text(
                              l10n.classModePlaceholder,
                              style: TahfeezTextStyles.bodyMd.copyWith(
                                color: TahfeezColors.onSurfaceVariant,
                              ),
                            ),
                            items: ClassMode.values
                                .map((mode) => DropdownMenuItem(
                                      value: mode,
                                      child: Text(
                                        mode.displayName,
                                        style:
                                            TahfeezTextStyles.bodyMd.copyWith(
                                          color: TahfeezColors.onSurface,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _selectedMode = v),
                            validator: (v) =>
                                v == null ? l10n.modeRequired : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit button
                  FilledButton(
                    onPressed: isSubmitting ? null : _submit,
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
                    child: isSubmitting
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
      },
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

  InputDecoration _inputDecoration({required String? hintText}) {
    return InputDecoration(
      hintText: hintText,
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
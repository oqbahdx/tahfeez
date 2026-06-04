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
      listenWhen: (previous, current) {
        return current is ClassOperationSuccess || current is ClassError;
      },
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
            title: Text(
              l10n.addClassTitle,
              style: TahfeezTextStyles.headlineLg.copyWith(
                color: TahfeezColors.onSurface,
                fontSize: 22,
              ),
            ),
            leading: const BackButton(color: TahfeezColors.primary),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSectionTitle(l10n.className),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(l10n.className),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.nameRequired;
                      }
                      if (value.trim().length > 100) {
                        return 'Class name is too long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle(l10n.classType),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ClassType>(
                    value: _selectedType,
                    decoration: _inputDecoration(null),
                    hint: Text(
                      l10n.classType,
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: TahfeezColors.onSurfaceVariant,
                      ),
                    ),
                    items: ClassType.values
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type.displayName),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedType = v),
                    validator: (v) => v == null ? l10n.typeRequired : null,
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle(l10n.classMode),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ClassMode>(
                    value: _selectedMode,
                    decoration: _inputDecoration(null),
                    hint: Text(
                      l10n.classMode,
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: TahfeezColors.onSurfaceVariant,
                      ),
                    ),
                    items: ClassMode.values
                        .map((mode) => DropdownMenuItem(
                              value: mode,
                              child: Text(mode.displayName),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedMode = v),
                    validator: (v) => v == null ? l10n.modeRequired : null,
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: isSubmitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: TahfeezColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: TahfeezColors.onPrimary,
                            ),
                          )
                        : Text(
                            l10n.submit,
                            style: TahfeezTextStyles.labelLg.copyWith(
                              color: TahfeezColors.onPrimary,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TahfeezTextStyles.titleLg.copyWith(
        color: TahfeezColors.onSurface,
      ),
    );
  }

  InputDecoration _inputDecoration(String? label) {
    return InputDecoration(
      hintText: label,
      filled: true,
      fillColor: TahfeezColors.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

}

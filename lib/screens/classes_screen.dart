import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../core/di/injection_container.dart' as di;
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../features/class/presentation/blocs/class_bloc.dart';
import '../features/class/presentation/blocs/class_event.dart';
import '../features/class/presentation/blocs/class_state.dart';
import '../features/class/domain/entities/class_entity.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/shared_widgets.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  bool _isPrivileged = false;
  bool _hasLoadedOnce = false;
  List<ClassEntity> _cachedClasses = [];
  bool _isAddDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _checkRole();
    context.read<ClassBloc>().add(GetAllClassesEvent());
  }

  Future<void> _checkRole() async {
    try {
      final apiClient = di.sl<ApiClient>();
      final token = await apiClient.getAccessToken();
      if (token == null || JwtDecoder.isExpired(token)) {
        if (mounted) setState(() {});
        return;
      }
      final claims = JwtDecoder.decode(token);
      final role = claims['role'] as String?;
      if (mounted) {
        setState(() {
          _isPrivileged = role == RoleConstants.admin || role == RoleConstants.supervisor;
        });
      }
    } catch (_) {
      if (mounted) setState(() {});
    }
  }

  void _showAddClassDialog() {
    final nameController = TextEditingController();
    int? selectedType;
    int? selectedMode;
    String? nameError;
    String? typeError;
    String? modeError;
    var isSubmitting = false;
    final l10n = AppLocalizations.of(context)!;

    _isAddDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: !isSubmitting,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.addClassTitle),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: l10n.className,
                        errorText: nameError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (_) {
                        if (nameError != null) {
                          setDialogState(() => nameError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: l10n.classType,
                        errorText: typeError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Boys')),
                        DropdownMenuItem(value: 2, child: Text('Girls')),
                      ],
                      onChanged: (v) {
                        setDialogState(() {
                          selectedType = v;
                          typeError = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedMode,
                      decoration: InputDecoration(
                        labelText: l10n.classMode,
                        errorText: modeError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Online')),
                        DropdownMenuItem(value: 2, child: Text('Offline')),
                      ],
                      onChanged: (v) {
                        setDialogState(() {
                          selectedMode = v;
                          modeError = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          final name = nameController.text.trim();
                          var valid = true;

                          if (name.isEmpty || name.length > 100) {
                            setDialogState(() => nameError = l10n.nameRequired);
                            valid = false;
                          }
                          if (selectedType == null) {
                            setDialogState(() => typeError = l10n.typeRequired);
                            valid = false;
                          }
                          if (selectedMode == null) {
                            setDialogState(() => modeError = l10n.modeRequired);
                            valid = false;
                          }
                          if (!valid) return;

                          setDialogState(() => isSubmitting = true);
                          context.read<ClassBloc>().add(CreateClassEvent(
                                name: name,
                                type: selectedType!,
                                mode: selectedMode!,
                              ));
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.submit),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      _isAddDialogOpen = false;
      nameController.dispose();
    });
  }

  void _showDeleteConfirmation(ClassEntity classEntity) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteClass),
        content: Text(l10n.deleteClassConfirmation(classEntity.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ClassBloc>().add(DeleteClassEvent(classEntity.id));
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<ClassBloc, ClassState>(
      listener: (context, state) {
        if (state is ClassOperationSuccess) {
          if (_isAddDialogOpen) {
            Navigator.of(context).pop();
            _isAddDialogOpen = false;
          }
          context.read<ClassBloc>().add(GetAllClassesEvent());
        } else if (state is ClassError && _hasLoadedOnce) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ClassesLoaded) {
          _cachedClasses = state.classes;
          _hasLoadedOnce = true;
        }

        final isLoading = state is ClassLoading;
        final showInitialLoading = !_hasLoadedOnce && state is ClassLoading;

        final initialErrorMessage = !_hasLoadedOnce && state is ClassError
            ? state.message
            : null;

        return Scaffold(
          backgroundColor: TahfeezColors.background,
          appBar: AppBar(
            title: Text(
              l10n.classesManagement,
              style: TahfeezTextStyles.headlineLg.copyWith(
                color: TahfeezColors.onSurface,
                fontSize: 22,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: TahfeezColors.onSurfaceVariant,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: _buildBody(l10n, showInitialLoading, initialErrorMessage, isLoading),
          floatingActionButton: _isPrivileged
              ? FloatingActionButton(
                  onPressed: _showAddClassDialog,
                  backgroundColor: TahfeezColors.primary,
                  foregroundColor: TahfeezColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, size: 28),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(
    AppLocalizations l10n,
    bool showInitialLoading,
    String? initialErrorMessage,
    bool isLoading,
  ) {
    if (showInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (initialErrorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                initialErrorMessage,
                style: TahfeezTextStyles.bodyMd.copyWith(
                  color: TahfeezColors.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () =>
                    context.read<ClassBloc>().add(GetAllClassesEvent()),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_cachedClasses.isEmpty) {
      return Center(
        child: Text(
          l10n.noClassesFound,
          style: TahfeezTextStyles.bodyLg.copyWith(
            color: TahfeezColors.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.classesCount(_cachedClasses.length),
            style: TahfeezTextStyles.titleLg.copyWith(
              color: TahfeezColors.onSurface,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            itemCount: _cachedClasses.length,
            itemBuilder: (context, i) => _ClassCard(
              classEntity: _cachedClasses[i],
              showDelete: _isPrivileged,
              deleteDisabled: isLoading,
              onDelete: () => _showDeleteConfirmation(_cachedClasses[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _ClassCard extends StatelessWidget {
  final ClassEntity classEntity;
  final bool showDelete;
  final bool deleteDisabled;
  final VoidCallback onDelete;

  const _ClassCard({
    required this.classEntity,
    required this.showDelete,
    required this.deleteDisabled,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classEntity.name,
                    style: TahfeezTextStyles.titleLg.copyWith(
                      color: TahfeezColors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      TahfeezChip(
                        label: classEntity.typeName,
                        bgColor:
                            TahfeezColors.primaryContainer.withOpacity(0.1),
                        textColor: TahfeezColors.primaryContainer,
                      ),
                      TahfeezChip(
                        label: classEntity.modeName,
                        bgColor: TahfeezColors.surfaceContainer,
                        textColor: TahfeezColors.onSurfaceVariant,
                        icon: classEntity.mode == 1
                            ? Icons.desktop_windows_outlined
                            : Icons.storefront_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.group_outlined,
                        size: 16,
                        color: TahfeezColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.studentsCount(classEntity.studentCount),
                        style: TahfeezTextStyles.labelMd.copyWith(
                          color: TahfeezColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showDelete)
              IconButton(
                onPressed: deleteDisabled ? null : onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: TahfeezColors.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../widgets/shared_widgets.dart';
import '../../domain/entities/class_entity.dart';

class ClassCard extends StatelessWidget {
  final ClassEntity classEntity;
  final bool showDelete;
  final bool deleteDisabled;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ClassCard({
    super.key,
    required this.classEntity,
    required this.showDelete,
    required this.deleteDisabled,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
                          icon: classEntity.classMode.value == 0
                              ? Icons.desktop_windows_outlined
                              : Icons.location_on_outlined,
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
      ),
    );
  }
}

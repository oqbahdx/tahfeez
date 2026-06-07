import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/enums/class_type.dart';
import '../../domain/enums/class_mode.dart';

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

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: TahfeezColors.surface,
              borderRadius: BorderRadius.circular(16),
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
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Accent left bar
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: TahfeezColors.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon container
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: TahfeezColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              size: 22,
                              color: TahfeezColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Text content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  classEntity.name,
                                  style: TahfeezTextStyles.titleLg.copyWith(
                                    color: TahfeezColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 5,
                                  children: [
                                    _PillChip(
                                      label: switch (classEntity.classType) {
                                        ClassType.boys => l10n.classTypeBoys,
                                        ClassType.girls => l10n.classTypeGirls,
                                      },
                                      icon: Icons.category_outlined,
                                      bgColor: TahfeezColors.primaryContainer
                                          .withOpacity(0.12),
                                      textColor:
                                          TahfeezColors.primaryContainer,
                                    ),
                                    _PillChip(
                                      label: switch (classEntity.classMode) {
                                        ClassMode.online => l10n.classModeOnline,
                                        ClassMode.offline => l10n.classModeOffline,
                                      },
                                      icon: classEntity.classMode.value == 0
                                          ? Icons.desktop_windows_outlined
                                          : Icons.location_on_outlined,
                                      bgColor:
                                          TahfeezColors.surfaceContainerLowest,
                                      textColor:
                                          TahfeezColors.onSurfaceVariant,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: TahfeezColors.surfaceContainer
                                            .withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.group_outlined,
                                            size: 13,
                                            color:
                                                TahfeezColors.onSurfaceVariant,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            l10n.studentsCount(
                                                classEntity.studentCount),
                                            style: TahfeezTextStyles.labelMd
                                                .copyWith(
                                              color: TahfeezColors
                                                  .onSurfaceVariant,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Delete button
                  if (showDelete)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: deleteDisabled ? null : onDelete,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: deleteDisabled
                                    ? TahfeezColors.surfaceContainer
                                        .withOpacity(0.3)
                                    : TahfeezColors.error.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: deleteDisabled
                                    ? TahfeezColors.onSurfaceVariant
                                        .withOpacity(0.3)
                                    : TahfeezColors.error,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  const _PillChip({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TahfeezTextStyles.labelMd.copyWith(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
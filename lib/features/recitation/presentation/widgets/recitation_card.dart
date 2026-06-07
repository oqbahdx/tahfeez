import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/recitation.dart';

class RecitationCard extends StatelessWidget {
  final Recitation recitation;

  const RecitationCard({super.key, required this.recitation});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRecitation = recitation.typeValue == 1;

    final typeColor = isRecitation
        ? TahfeezColors.primary
        : TahfeezColors.tertiary;
    final typeBgColor = isRecitation
        ? TahfeezColors.primary.withOpacity(0.12)
        : TahfeezColors.tertiary.withOpacity(0.12);

    final gradeColor = recitation.grade >= 8
        ? TahfeezColors.primary
        : recitation.grade >= 5
            ? TahfeezColors.secondary
            : TahfeezColors.error;

    final gradeLabel = recitation.gradeLabel ??
        (recitation.grade >= 8
            ? l10n.excellentGrade
            : recitation.grade >= 5
                ? l10n.gradeGood
                : l10n.gradeNeedsWork);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TahfeezColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: TahfeezColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(recitation.date),
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                        ),
                        if (recitation.teacherName != null) ...[
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.person_outline,
                            size: 12,
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            recitation.teacherName!,
                            style: TahfeezTextStyles.labelMd.copyWith(
                              color: TahfeezColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.ayahsCountText(recitation.ayahsCount),
                      style: TahfeezTextStyles.titleLg.copyWith(
                        color: TahfeezColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeBgColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isRecitation
                      ? l10n.recitationTypeRecitation
                      : l10n.reviewMurajaah,
                  style: TahfeezTextStyles.labelMd.copyWith(
                    color: typeColor,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: TahfeezColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: TahfeezColors.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: gradeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      gradeLabel,
                      style: TahfeezTextStyles.labelLg.copyWith(
                        color: gradeColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: gradeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${recitation.grade}/10',
                        style: TahfeezTextStyles.labelMd.copyWith(
                          color: gradeColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (recitation.notes != null && recitation.notes!.isNotEmpty) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '"${recitation.notes}"',
                    style: TahfeezTextStyles.bodyMd.copyWith(
                      color: TahfeezColors.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

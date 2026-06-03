import 'package:flutter/material.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';

class RecitationHistoryScreen extends StatefulWidget {
  final String studentName;
  const RecitationHistoryScreen({super.key, required this.studentName});

  @override
  State<RecitationHistoryScreen> createState() =>
      _RecitationHistoryScreenState();
}

class _RecitationHistoryScreenState extends State<RecitationHistoryScreen> {
  String _selectedMonth = 'October 2023';

  final _months = ['October 2023', 'September 2023', 'August 2023'];

  final _records = const [
    _RecitationRecord(
      date: '15 Oct 2023',
      surah: 'Surah Al-Mulk',
      ayahs: 'Ayahs 1 - 15',
      type: 'New Lesson (Sabaq)',
      typeColor: TahfeezColors.primaryContainer,
      typeTextColor: TahfeezColors.onPrimaryContainer,
      grade: 'Excellent',
      gradeColor: TahfeezColors.primary,
      note: 'Perfect makharij and fluent reading today.',
    ),
    _RecitationRecord(
      date: '14 Oct 2023',
      surah: 'Surah At-Tahrim',
      ayahs: 'Full Surah',
      type: "Recent Revision (Sabaqi)",
      typeColor: TahfeezColors.tertiaryContainer,
      typeTextColor: TahfeezColors.onTertiaryContainer,
      grade: 'Good',
      gradeColor: TahfeezColors.secondary,
      note: 'Stumbled on verses 4-5, needs minor review.',
    ),
    _RecitationRecord(
      date: '12 Oct 2023',
      surah: 'Juz 29',
      ayahs: 'First Quarter',
      type: 'Old Revision (Manzil)',
      typeColor: TahfeezColors.surfaceVariant,
      typeTextColor: TahfeezColors.onSurfaceVariant,
      grade: 'Needs Work',
      gradeColor: TahfeezColors.error,
      note: 'Forgotten multiple sections, repeat tomorrow.',
    ),
    _RecitationRecord(
      date: '10 Oct 2023',
      surah: 'Surah At-Taghabun',
      ayahs: 'Ayahs 1 - 18 (Full)',
      type: 'New Lesson (Sabaq)',
      typeColor: TahfeezColors.primaryContainer,
      typeTextColor: TahfeezColors.onPrimaryContainer,
      grade: 'Excellent',
      gradeColor: TahfeezColors.primary,
      note: '',
    ),
    _RecitationRecord(
      date: '8 Oct 2023',
      surah: 'Surah Al-Hashr',
      ayahs: 'Ayahs 18 - 24',
      type: 'New Lesson (Sabaq)',
      typeColor: TahfeezColors.primaryContainer,
      typeTextColor: TahfeezColors.onPrimaryContainer,
      grade: 'Excellent',
      gradeColor: TahfeezColors.primary,
      note: 'Beautiful recitation with proper tajweed.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: TahfeezColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        leading: const BackButton(color: TahfeezColors.primaryContainer),
        title: Text(
          l10n.recitationHistory,
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
      body: Column(
        children: [
          // Header context
          Container(
            color: TahfeezColors.surfaceContainerLowest,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studentName,
                  style: TahfeezTextStyles.bodyLg.copyWith(
                    color: TahfeezColors.onSurfaceVariant,
                  ),
                ),
                // Month filter row
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._months.map((m) {
                        final isSelected = _selectedMonth == m;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => setState(() => _selectedMonth = m),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? TahfeezColors.primary
                                    : TahfeezColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : TahfeezColors.outlineVariant,
                                ),
                              ),
                              child: Text(
                                m,
                                style: TahfeezTextStyles.labelLg.copyWith(
                                  color: isSelected
                                      ? TahfeezColors.onPrimary
                                      : TahfeezColors.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: TahfeezColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: TahfeezColors.outlineVariant,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.filter_list,
                              size: 16,
                              color: TahfeezColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.moreFilters,
                              style: TahfeezTextStyles.labelLg.copyWith(
                                color: TahfeezColors.primary,
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Monthly summary
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: TahfeezColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: TahfeezColors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.monthlyProgress.toUpperCase(),
                                style: TahfeezTextStyles.labelMd.copyWith(
                                  color: TahfeezColors.onSurfaceVariant,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '18 ${l10n.sessions}',
                                    style: TahfeezTextStyles.titleLg.copyWith(
                                      color: TahfeezColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: TahfeezColors.outlineVariant,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _CategoryCard(
                                    title: l10n.newLessonSabaq,
                                    count: 5,
                                    color: TahfeezColors.primaryContainer,
                                  ),
                                  _CategoryCard(
                                    title: l10n.recentRevisionSabaqi,
                                    count: 8,
                                    color: TahfeezColors.secondaryContainer,
                                  ),
                                  _CategoryCard(
                                    title: l10n.oldRevisionManzil,
                                    count: 5,
                                    color: TahfeezColors.tertiaryContainer,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: TahfeezColors.primaryFixed,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(
                            Icons.trending_up,
                            color: TahfeezColors.onPrimaryFixedVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Recitation cards
                  ...(_records.map((r) => _RecitationCard(record: r))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecitationCard extends StatelessWidget {
  final _RecitationRecord record;
  const _RecitationCard({required this.record});

  @override
  Widget build(BuildContext context) {
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
                          record.date,
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: TahfeezColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.surah,
                      style: TahfeezTextStyles.titleLg.copyWith(
                        color: TahfeezColors.onSurface,
                      ),
                    ),
                    Text(
                      record.ayahs,
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: TahfeezColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: record.typeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  record.type,
                  style: TahfeezTextStyles.labelMd.copyWith(
                    color: record.typeTextColor,
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
                        color: record.gradeColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      record.grade,
                      style: TahfeezTextStyles.labelLg.copyWith(
                        color: record.gradeColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (record.note.isNotEmpty) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '"${record.note}"',
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
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _CategoryCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count ',
            style: TahfeezTextStyles.labelLg.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(title, style: TahfeezTextStyles.labelMd.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _RecitationRecord {
  final String date, surah, ayahs, type, grade, note;
  final Color typeColor, typeTextColor, gradeColor;

  const _RecitationRecord({
    required this.date,
    required this.surah,
    required this.ayahs,
    required this.type,
    required this.typeColor,
    required this.typeTextColor,
    required this.grade,
    required this.gradeColor,
    required this.note,
  });
}

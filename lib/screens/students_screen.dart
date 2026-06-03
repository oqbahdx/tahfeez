import 'package:flutter/material.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';
import 'recitation_history_screen.dart';
import 'log_recitation_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final _searchController = TextEditingController();
  String _filter = 'All';

  final _students = const [
    _StudentData(
      name: 'Ahmad Abdullah',
      id: '1001',
      program: 'Hifz Program',
      surah: 'Surah Al-Mulk',
      progress: 0.72,
      initials: 'AA',
      status: 'excellent',
    ),
    _StudentData(
      name: 'Fatima Zahra',
      id: '1045',
      program: 'Tajweed Basics',
      surah: "Juz' Amma",
      progress: 0.91,
      initials: 'FZ',
      status: 'good',
    ),
    _StudentData(
      name: 'Omar Tariq',
      id: '1051',
      program: 'Hifz Program',
      surah: 'Juz 29 Revision',
      progress: 0.81,
      initials: 'OT',
      status: 'needsWork',
    ),
    _StudentData(
      name: 'Zainab Khalil',
      id: '1033',
      program: 'Qaida Noorania',
      surah: 'Lesson 12',
      progress: 0.55,
      initials: 'ZK',
      status: 'good',
    ),
    _StudentData(
      name: 'Yusuf Ibrahim',
      id: '1058',
      program: 'Hifz Program',
      surah: 'Surah At-Taghabun',
      progress: 0.95,
      initials: 'YI',
      status: 'excellent',
    ),
    _StudentData(
      name: 'Layla Mahmoud',
      id: '1062',
      program: "Qira'at Specialization",
      surah: 'Surah Al-Baqarah 50-80',
      progress: 0.68,
      initials: 'LM',
      status: 'good',
    ),
    _StudentData(
      name: 'Ibrahim Said',
      id: '1077',
      program: 'Hifz Program',
      surah: 'New: Surah Al-Imran',
      progress: 0.40,
      initials: 'IS',
      status: 'needsWork',
    ),
    _StudentData(
      name: 'Nour Hassan',
      id: '1089',
      program: 'Tajweed Basics',
      surah: 'Makharij practice',
      progress: 0.85,
      initials: 'NH',
      status: 'excellent',
    ),
  ];

  List<_StudentData> get _filtered {
    final q = _searchController.text.toLowerCase();
    return _students.where((s) {
      final matchesSearch =
          s.name.toLowerCase().contains(q) ||
          s.program.toLowerCase().contains(q);
      final matchesFilter =
          _filter == 'All' ||
          (_filter == 'Excellent' && s.status == 'excellent') ||
          (_filter == 'Needs Work' && s.status == 'needsWork');
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: TahfeezColors.background,
      appBar: AppBar(
        title: Text(
          l10n.students,
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
          // Search + filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: TahfeezColors.outline,
                      ),
                      hintText: l10n.searchStudents,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: TahfeezColors.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: TahfeezColors.secondary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: TahfeezColors.surfaceContainerLowest,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    [
                      l10n.filterChipsAll,
                      l10n.filterChipsExcellent,
                      l10n.filterChipsGood,
                      l10n.filterChipsNeedsWork,
                    ].map((f) {
                      final isSelected = _filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(f),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _filter = f),
                          backgroundColor: TahfeezColors.surfaceContainerLowest,
                          selectedColor: TahfeezColors.primaryContainer
                              .withOpacity(0.15),
                          checkmarkColor: TahfeezColors.primaryContainer,
                          labelStyle: TahfeezTextStyles.labelLg.copyWith(
                            color: isSelected
                                ? TahfeezColors.primaryContainer
                                : TahfeezColors.onSurfaceVariant,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? TahfeezColors.primaryContainer
                                : TahfeezColors.outlineVariant,
                          ),
                          shape: const StadiumBorder(),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  l10n.studentsCount(_filtered.length),
                  style: TahfeezTextStyles.labelMd.copyWith(
                    color: TahfeezColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Student list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _StudentCard(
                student: _filtered[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RecitationHistoryScreen(studentName: _filtered[i].name),
                  ),
                ),
                onLogRecitation: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LogRecitationScreen(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: TahfeezColors.primary,
        foregroundColor: TahfeezColors.onPrimary,
        icon: const Icon(Icons.person_add_outlined),
        label: Text(
          l10n.addStudent,
          style: TahfeezTextStyles.labelLg.copyWith(
            color: TahfeezColors.onPrimary,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final _StudentData student;
  final VoidCallback onTap;
  final VoidCallback onLogRecitation;

  const _StudentCard({
    required this.student,
    required this.onTap,
    required this.onLogRecitation,
  });

  Color get _statusColor {
    switch (student.status) {
      case 'excellent':
        return TahfeezColors.primary;
      case 'needsWork':
        return TahfeezColors.error;
      default:
        return TahfeezColors.secondary;
    }
  }

  String get _statusLabel {
    switch (student.status) {
      case 'excellent':
        return 'Excellent';
      case 'needsWork':
        return 'Needs Work';
      default:
        return 'Good';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: TahfeezColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: TahfeezColors.outlineVariant.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: TahfeezColors.primaryFixed.withOpacity(0.5),
              child: Text(
                student.initials,
                style: TahfeezTextStyles.labelLg.copyWith(
                  color: TahfeezColors.primaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        student.name,
                        style: TahfeezTextStyles.labelLg.copyWith(
                          color: TahfeezColors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _statusLabel,
                          style: TahfeezTextStyles.labelMd.copyWith(
                            color: _statusColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    student.program,
                    style: TahfeezTextStyles.labelMd.copyWith(
                      color: TahfeezColors.primaryContainer,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    student.surah,
                    style: TahfeezTextStyles.bodyMd.copyWith(
                      color: TahfeezColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: student.progress,
                            minHeight: 4,
                            backgroundColor: TahfeezColors.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation(_statusColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(student.progress * 100).round()}%',
                        style: TahfeezTextStyles.labelMd.copyWith(
                          color: TahfeezColors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'log') onLogRecitation();
                if (v == 'history') onTap();
              },
              icon: const Icon(
                Icons.more_vert,
                color: TahfeezColors.onSurfaceVariant,
                size: 20,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'log', child: Text('Log Recitation')),
                PopupMenuItem(value: 'history', child: Text('View History')),
                PopupMenuItem(value: 'attendance', child: Text('Attendance')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentData {
  final String name, id, program, surah, initials, status;
  final double progress;

  const _StudentData({
    required this.name,
    required this.id,
    required this.program,
    required this.surah,
    required this.progress,
    required this.initials,
    required this.status,
  });
}

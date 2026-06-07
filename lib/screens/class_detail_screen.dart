import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/shared_widgets.dart';
import '../features/attendance/presentation/bloc/attendance_bloc.dart';
import '../features/attendance/presentation/pages/attendance_by_date_page.dart';

class ClassDetailScreen extends StatefulWidget {
  final dynamic classData;
  const ClassDetailScreen({super.key, required this.classData});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _students = const [
    ('Omar Khaled', "Juz' Amma - Surah Al-Fajr", 'OK'),
    ('Zainab Abdallah', "Juz' Tabarak - Surah Al-Mulk", 'ZA'),
    ('Tariq Hassan', 'Revision: Juz 1-5', 'TH'),
    ('Layla Mahmoud', 'Surah Al-Baqarah Ayah 50-80', 'LM'),
    ('Ibrahim Said', 'New: Surah Al-Imran', 'IS'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: TahfeezColors.background,
      appBar: AppBar(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        leading: const BackButton(color: TahfeezColors.primary),
        title: Text(
          l10n.classDetails,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TahfeezColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: TahfeezColors.outlineVariant.withOpacity(0.3),
                ),
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
                            Text(
                              'Advanced Tajweed - Group A',
                              style: TahfeezTextStyles.headlineLg.copyWith(
                                color: TahfeezColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                TahfeezChip(
                                  label: l10n.typeRecitation,
                                  bgColor: TahfeezColors.primaryContainer
                                      .withOpacity(0.1),
                                  textColor: TahfeezColors.primaryContainer,
                                  icon: Icons.school_outlined,
                                ),
                                TahfeezChip(
                                  label: l10n.modeInPerson,
                                  bgColor: TahfeezColors.secondaryContainer
                                      .withOpacity(0.2),
                                  textColor: TahfeezColors.secondary,
                                  icon: Icons.location_on_outlined,
                                ),
                                TahfeezChip(
                                  label: l10n.levelAdvanced,
                                  bgColor: TahfeezColors.surfaceVariant,
                                  textColor: TahfeezColors.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: TahfeezColors.primary,
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(Icons.person_add_outlined, size: 16),
                        label: Text(
                          l10n.assignStaff,
                          style: TahfeezTextStyles.labelLg.copyWith(
                            color: TahfeezColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    l10n.assignedStaff,
                    style: TahfeezTextStyles.titleLg.copyWith(
                      color: TahfeezColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          children: const [
                            Expanded(
                              child: _StaffCard(
                                name: 'Ahmed Yassin',
                                role: 'Primary Teacher',
                                initials: 'AY',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _StaffCard(
                                name: 'Fatima Ali',
                                role: 'Assistant',
                                initials: 'FA',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _StaffCard(
                                name: 'Mahmoud Omar',
                                role: 'Supervisor',
                                initials: 'MO',
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: const [
                          _StaffCard(
                            name: 'Ahmed Yassin',
                            role: 'Primary Teacher',
                            initials: 'AY',
                          ),
                          SizedBox(height: 8),
                          _StaffCard(
                            name: 'Fatima Ali',
                            role: 'Assistant',
                            initials: 'FA',
                          ),
                          SizedBox(height: 8),
                          _StaffCard(
                            name: 'Mahmoud Omar',
                            role: 'Supervisor',
                            initials: 'MO',
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tab section
            Container(
              decoration: BoxDecoration(
                color: TahfeezColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: TahfeezColors.outlineVariant.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: TahfeezColors.primary,
                    unselectedLabelColor: TahfeezColors.onSurfaceVariant,
                    indicatorColor: TahfeezColors.primary,
                    labelStyle: TahfeezTextStyles.labelLg,
                    unselectedLabelStyle: TahfeezTextStyles.labelLg,
                    tabs: [
                      Tab(text: l10n.students),
                      Tab(text: l10n.attendance),
                      Tab(text: l10n.progress),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Students tab
                        Column(
                          children: [
                            ..._students.map(
                              (s) => _StudentRow(
                                name: s.$1,
                                detail: s.$2,
                                initials: s.$3,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                l10n.viewAllStudents,
                                style: TahfeezTextStyles.labelLg.copyWith(
                                  color: TahfeezColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Attendance tab
                        Center(
                          child: FilledButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                          final bloc = context.read<AttendanceBloc>();
                          return BlocProvider.value(
                            value: bloc,
                            child: AttendanceByDatePage(
                              classId: 'class-1',
                              className: 'Advanced Tajweed - Group A',
                            ),
                          );
                        },
                              ),
                            ),
                            icon: const Icon(Icons.how_to_reg),
                            label: Text(l10n.openAttendance),
                            style: FilledButton.styleFrom(
                              backgroundColor: TahfeezColors.primary,
                            ),
                          ),
                        ),
                        // Progress tab
                        Center(
                          child: Text(
                            l10n.progressChartsComingSoon,
                            style: TextStyle(
                              color: TahfeezColors.onSurfaceVariant,
                            ),
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
    );
  }
}

class _StaffCard extends StatelessWidget {
  final String name, role, initials;

  const _StaffCard({
    required this.name,
    required this.role,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: TahfeezColors.outlineVariant.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: TahfeezColors.primaryFixed,
            child: Text(
              initials,
              style: TahfeezTextStyles.labelMd.copyWith(
                color: TahfeezColors.onPrimaryFixed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TahfeezTextStyles.labelLg.copyWith(
                    color: TahfeezColors.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  role,
                  style: TahfeezTextStyles.bodyMd.copyWith(
                    color: TahfeezColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  final String name, detail, initials;

  const _StudentRow({
    required this.name,
    required this.detail,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: TahfeezColors.secondaryContainer,
        child: Text(
          initials,
          style: TahfeezTextStyles.labelMd.copyWith(
            color: TahfeezColors.onSecondaryContainer,
          ),
        ),
      ),
      title: Text(
        name,
        style: TahfeezTextStyles.labelLg.copyWith(
          color: TahfeezColors.onSurface,
        ),
      ),
      subtitle: Text(
        detail,
        style: TahfeezTextStyles.bodyMd.copyWith(
          color: TahfeezColors.onSurfaceVariant,
        ),
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.more_vert,
          color: TahfeezColors.primary,
          size: 20,
        ),
      ),
    );
  }
}

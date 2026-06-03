import 'package:flutter/material.dart';
import '../core/utils/toast_helper.dart';
import '../theme/tahfeez_theme.dart';
import '../l10n/app_localizations.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _students = [
    _StudentAttendance(
      name: 'Zayd ibn Thabit',
      detail: 'Surah Al-Baqarah, Ayah 145',
      initials: 'ZT',
      status: 'present',
    ),
    _StudentAttendance(
      name: 'Ali Abdul-Rahman',
      detail: 'Juz 30 Revision',
      initials: 'AA',
      status: 'absent',
    ),
    _StudentAttendance(
      name: 'Omar Farooq',
      detail: 'Surah Al-Kahf',
      initials: 'OF',
      status: 'excused',
    ),
    _StudentAttendance(
      name: 'Fatima Zahra',
      detail: 'Juz 29 - Surah Al-Mulk',
      initials: 'FZ',
      status: 'present',
    ),
    _StudentAttendance(
      name: 'Ibrahim Khalil',
      detail: 'New: Surah At-Talaq',
      initials: 'IK',
      status: 'present',
    ),
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
          l10n.recordAttendance,
          style: TahfeezTextStyles.headlineLg.copyWith(
            color: TahfeezColors.onSurface,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          // Session info bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TahfeezColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TahfeezColors.outlineVariant),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: TahfeezColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: TahfeezColors.outlineVariant.withOpacity(
                              0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.chevron_left,
                                color: TahfeezColors.onSurfaceVariant,
                              ),
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.calendar_today,
                              color: TahfeezColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n.hijriDateShort,
                              style: TahfeezTextStyles.labelMd.copyWith(
                                color: TahfeezColors.onSurface,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.chevron_right,
                                color: TahfeezColors.onSurfaceVariant,
                              ),
                              iconSize: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: TahfeezColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: TahfeezColors.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.filter_list,
                        color: TahfeezColors.onSurfaceVariant,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Hifz Class A',
                        style: TahfeezTextStyles.titleLg.copyWith(
                          color: TahfeezColors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: TahfeezColors.onSurfaceVariant,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Student list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _students.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _AttendanceCard(
                student: _students[i],
                onStatusChanged: (status) {
                  setState(() => _students[i].status = status);
                },
              ),
            ),
          ),

          // Submit button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Divider(),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () {
                    AppToast.success(l10n.attendanceSubmitted);
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: TahfeezColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(
                    l10n.present,
                    style: TahfeezTextStyles.labelLg.copyWith(
                      color: TahfeezColors.primary,
                    ),
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

class _StudentAttendance {
  final String name, detail, initials;
  String status;

  _StudentAttendance({
    required this.name,
    required this.detail,
    required this.initials,
    required this.status,
  });
}

class _AttendanceCard extends StatelessWidget {
  final _StudentAttendance student;
  final ValueChanged<String> onStatusChanged;

  const _AttendanceCard({required this.student, required this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 500;
          if (isWide) {
            return Row(
              children: [
                _buildStudentInfo(),
                const Spacer(),
                _buildStatusToggle(),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStudentInfo(),
              const SizedBox(height: 12),
              _buildStatusToggle(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStudentInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: TahfeezColors.primaryFixedDim.withOpacity(0.4),
          child: Text(
            student.initials,
            style: TahfeezTextStyles.labelLg.copyWith(
              color: TahfeezColors.onPrimaryFixed,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.name,
              style: TahfeezTextStyles.titleLg.copyWith(
                color: TahfeezColors.onSurface,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: TahfeezColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  student.detail,
                  style: TahfeezTextStyles.bodyMd.copyWith(
                    color: TahfeezColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusOption(
            label: 'Present',
            isSelected: student.status == 'present',
            selectedBg: TahfeezColors.primaryContainer,
            selectedText: TahfeezColors.onPrimaryContainer,
            onTap: () => onStatusChanged('present'),
          ),
          _StatusOption(
            label: 'Absent',
            isSelected: student.status == 'absent',
            selectedBg: TahfeezColors.errorContainer,
            selectedText: TahfeezColors.onErrorContainer,
            onTap: () => onStatusChanged('absent'),
          ),
          _StatusOption(
            label: 'Excused',
            isSelected: student.status == 'excused',
            selectedBg: TahfeezColors.secondaryContainer,
            selectedText: TahfeezColors.onSecondaryContainer,
            onTap: () => onStatusChanged('excused'),
          ),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedBg, selectedText;
  final VoidCallback onTap;

  const _StatusOption({
    required this.label,
    required this.isSelected,
    required this.selectedBg,
    required this.selectedText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TahfeezTextStyles.labelLg.copyWith(
            color: isSelected ? selectedText : TahfeezColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

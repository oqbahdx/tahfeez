import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../class/presentation/blocs/class_bloc.dart';
import '../../../class/presentation/blocs/class_state.dart';
import '../../../class/domain/entities/class_entity.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/enums/attendance_status.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_shimmer.dart';
import '../widgets/attendance_error_view.dart';
import '../widgets/attendance_empty_view.dart';
import '../widgets/attendance_summary_card.dart';
import '../widgets/attendance_report_table.dart';

class AttendanceReportPage extends StatefulWidget {
  const AttendanceReportPage({super.key});

  @override
  State<AttendanceReportPage> createState() => _AttendanceReportPageState();
}

class _AttendanceReportPageState extends State<AttendanceReportPage> {
  String? _selectedClassId;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = now;
  }

  void _fetchReport() {
    if (_selectedClassId == null) {
      AppToast.error('Please select a class');
      return;
    }
    context.read<AttendanceBloc>().add(
      FetchAttendanceReport(
        classId: _selectedClassId!,
        from: _startDate,
        to: _endDate,
      ),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: TahfeezColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: TahfeezColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        title: Text(
          l10n.attendanceReport,
          style: TahfeezTextStyles.headlineLg.copyWith(
            color: TahfeezColors.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: TahfeezColors.surfaceContainerLowest,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                BlocBuilder<ClassBloc, ClassState>(
                  builder: (context, classState) {
                    List<ClassEntity> classes = [];
                    if (classState is ClassesLoaded) {
                      classes = classState.classes;
                    }
                    return DropdownButtonFormField<String>(
                      value: _selectedClassId,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: TahfeezColors.surfaceContainer,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: TahfeezColors.outlineVariant,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        hintText: 'Select Class',
                      ),
                      items: classes
                          .map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.name),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() => _selectedClassId = v);
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(isStart: true),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: TahfeezColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TahfeezColors.outlineVariant,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From',
                                style: TahfeezTextStyles.labelMd.copyWith(
                                  color: TahfeezColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(_startDate),
                                style: TahfeezTextStyles.bodyMd.copyWith(
                                  color: TahfeezColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(isStart: false),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: TahfeezColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: TahfeezColors.outlineVariant,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'To',
                                style: TahfeezTextStyles.labelMd.copyWith(
                                  color: TahfeezColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(_endDate),
                                style: TahfeezTextStyles.bodyMd.copyWith(
                                  color: TahfeezColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _fetchReport,
                    style: FilledButton.styleFrom(
                      backgroundColor: TahfeezColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.search, size: 18),
                    label: const Text('Generate Report'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<AttendanceBloc, AttendanceState>(
              listenWhen: (previous, current) => current is AttendanceError,
              listener: (context, state) {
                if (state is AttendanceError) {
                  if (context.read<AttendanceBloc>().state
                      is! AttendanceLoaded) {
                    AppToast.error(state.message);
                  }
                }
              },
              builder: (context, state) {
                final isLoading = state is AttendanceLoading;
                final error = state is AttendanceError;
                final hasData = state is AttendanceLoaded;
                final isEmpty = state is AttendanceEmpty;

                final List<Attendance> attendances =
                    hasData ? state.attendances : [];

                if (isLoading && !hasData && !isEmpty) {
                  return const AttendanceShimmer();
                }

                if (error && !hasData && !isEmpty) {
                  return AttendanceErrorView(
                    message: state.message,
                    onRetry: _fetchReport,
                  );
                }

                if ((isEmpty || attendances.isEmpty) && !isLoading) {
                  return AttendanceEmptyView(
                    title: 'No report data',
                    subtitle:
                        'No attendance records found for the selected filters.',
                    onRetry: _fetchReport,
                  );
                }

                if (!hasData) {
                  return Center(
                    child: Text(
                      'Select filters and generate report',
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: TahfeezColors.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return _buildReportContent(attendances);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(List<Attendance> attendances) {
    final uniqueStudents = <String>{};
    for (final a in attendances) {
      uniqueStudents.add(a.userName ?? a.userId);
    }

    final totalStudents = uniqueStudents.length;

    final studentStats = <String, _Stats>{};
    for (final a in attendances) {
      final name = a.userName ?? a.userId;
      final stats = studentStats.putIfAbsent(name, () => _Stats());
      switch (a.status) {
        case AttendanceStatus.present:
          stats.present++;
        case AttendanceStatus.absent:
          stats.absent++;
        case AttendanceStatus.late:
          stats.late++;
      }
    }

    double totalPct = 0;
    String? mostAbsentName;
    int maxAbsent = 0;
    String? mostLateName;
    int maxLate = 0;

    for (final entry in studentStats.entries) {
      final s = entry.value;
      final total = s.present + s.absent + s.late;
      final pct = total > 0 ? (s.present / total * 100) : 0.0;
      totalPct += pct;

      if (s.absent > maxAbsent) {
        maxAbsent = s.absent;
        mostAbsentName = entry.key;
      }
      if (s.late > maxLate) {
        maxLate = s.late;
        mostLateName = entry.key;
      }
    }

    final avgPct = studentStats.isNotEmpty
        ? (totalPct / studentStats.length).toStringAsFixed(1)
        : '0.0';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            AttendanceSummaryCard(
              icon: Icons.people_outline,
              label: 'Total Students',
              value: '$totalStudents',
            ),
            AttendanceSummaryCard(
              icon: Icons.trending_up,
              label: 'Avg Attendance %',
              value: '$avgPct%',
              iconBgColor:
                  AttendanceStatus.present.statusColor.withOpacity(0.1),
              iconColor: AttendanceStatus.present.statusColor,
              valueColor: AttendanceStatus.present.statusColor,
            ),
            AttendanceSummaryCard(
              icon: Icons.person_off_outlined,
              label: 'Most Absent',
              value: mostAbsentName ?? '-',
              iconBgColor:
                  AttendanceStatus.absent.statusColor.withOpacity(0.1),
              iconColor: AttendanceStatus.absent.statusColor,
              valueColor: AttendanceStatus.absent.statusColor,
            ),
            AttendanceSummaryCard(
              icon: Icons.access_time,
              label: 'Most Late',
              value: mostLateName ?? '-',
              iconBgColor: AttendanceStatus.late.statusColor.withOpacity(0.1),
              iconColor: AttendanceStatus.late.statusColor,
              valueColor: AttendanceStatus.late.statusColor,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Attendance Breakdown',
          style: TahfeezTextStyles.titleLg.copyWith(
            color: TahfeezColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        AttendanceReportTable(attendances: attendances),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TahfeezColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: TahfeezColors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export Options',
                style: TahfeezTextStyles.titleLg.copyWith(
                  color: TahfeezColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        AppToast.info('PDF export coming soon');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.picture_as_pdf, size: 18),
                      label: const Text('Export PDF'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        AppToast.info('Excel export coming soon');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.table_chart_outlined, size: 18),
                      label: const Text('Export Excel'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stats {
  int present = 0;
  int absent = 0;
  int late = 0;
}

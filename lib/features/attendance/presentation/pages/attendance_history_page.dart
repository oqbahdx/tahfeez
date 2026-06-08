import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth/auth_service.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/utils/toast_helper.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/enums/attendance_status.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_shimmer.dart';
import '../widgets/attendance_error_view.dart';
import '../widgets/attendance_empty_view.dart';
import '../extensions/attendance_status_ext.dart';
import '../widgets/attendance_summary_card.dart';
import '../widgets/attendance_calendar.dart';
import '../widgets/attendance_timeline_tile.dart';

class AttendanceHistoryPage extends StatefulWidget {
  final String userId;
  final String? userName;

  const AttendanceHistoryPage({
    super.key,
    required this.userId,
    this.userName,
  });

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<AttendanceBloc>()
        .add(FetchAttendanceHistory(widget.userId));
  }

  Future<void> _onRefresh() async {
    context
        .read<AttendanceBloc>()
        .add(FetchAttendanceHistory(widget.userId));
  }

  Future<void> _showAddAttendanceDialog() async {
    final l10n = AppLocalizations.of(context)!;
    var selectedDate = DateTime.now();
    var selectedStatus = AttendanceStatus.present;
    final notesController = TextEditingController();

    final bloc = context.read<AttendanceBloc>();

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: TahfeezColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.addAttendanceRecord,
            style: TahfeezTextStyles.titleLg.copyWith(
              color: TahfeezColors.onSurface,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context)
                            .colorScheme
                            .copyWith(primary: TahfeezColors.primary),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    setDialogState(() => selectedDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: TahfeezColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: TahfeezColors.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: TahfeezColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                        style: TahfeezTextStyles.labelLg.copyWith(
                          color: TahfeezColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<AttendanceStatus>(
                value: selectedStatus,
                decoration: InputDecoration(
                  labelText: l10n.status,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: TahfeezColors.outlineVariant),
                  ),
                  filled: true,
                  fillColor: TahfeezColors.surfaceContainer,
                ),
                items: AttendanceStatus.values.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s.localizedName(l10n)),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    setDialogState(() => selectedStatus = v);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: l10n.notesOptional,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: TahfeezColors.outlineVariant),
                  ),
                  filled: true,
                  fillColor: TahfeezColors.surfaceContainer,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.cancel,
                style: TahfeezTextStyles.labelLg.copyWith(
                  color: TahfeezColors.onSurfaceVariant,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                bloc.add(
                  RecordAttendanceEvent([
                    {
                      'userId': widget.userId,
                      'date': selectedDate,
                      'status': selectedStatus.toApi(),
                      'notes': notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                    },
                  ]),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: TahfeezColors.primary,
              ),
              child: Text(
                l10n.save,
                style: TahfeezTextStyles.labelLg.copyWith(
                  color: TahfeezColors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: TahfeezColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: TahfeezColors.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: TahfeezColors.surfaceContainer,
                width: 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: TahfeezColors.onSurface,
              ),
            ),
          ),
        ),
        title: Text(
          l10n.attendanceHistory,
          style: TahfeezTextStyles.headlineLg.copyWith(
            color: TahfeezColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: di.sl<AuthService>().canAccessAttendance
            ? [
                TextButton.icon(
                  onPressed: _showAddAttendanceDialog,
                  icon: const Icon(
                    Icons.add,
                    size: 18,
                    color: TahfeezColors.primary,
                  ),
                  label: Text(
                    l10n.addAttendance,
                    style: TahfeezTextStyles.labelLg.copyWith(
                      color: TahfeezColors.primary,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listenWhen: (previous, current) =>
            current is AttendanceError || current is AttendanceSuccess,
        listener: (context, state) {
          if (state is AttendanceSuccess) {
            AppToast.success(state.message);
            _onRefresh();
          } else if (state is AttendanceError) {
            if (context.read<AttendanceBloc>().state is! AttendanceLoaded) {
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

          final presentCount = attendances
              .where((a) => a.status == AttendanceStatus.present)
              .length;
          final absentCount = attendances
              .where((a) => a.status == AttendanceStatus.absent)
              .length;
          final lateCount = attendances
              .where((a) => a.status == AttendanceStatus.late)
              .length;
          final total = attendances.length;
          final attendancePct = total > 0
              ? (presentCount / total * 100).toStringAsFixed(1)
              : '0.0';

          return Column(
            children: [
              if (widget.userName != null)
                Container(
                  color: TahfeezColors.surfaceContainerLowest,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  width: double.infinity,
                  child: Text(
                    widget.userName!,
                    style: TahfeezTextStyles.bodyLg.copyWith(
                      color: TahfeezColors.onSurfaceVariant,
                    ),
                  ),
                ),
              Expanded(
                child: _buildBody(
                  l10n,
                  isLoading,
                  error,
                  hasData,
                  isEmpty,
                  attendances,
                  presentCount,
                  absentCount,
                  lateCount,
                  attendancePct,
                  state,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    AppLocalizations l10n,
    bool isLoading,
    bool error,
    bool hasData,
    bool isEmpty,
    List<Attendance> attendances,
    int presentCount,
    int absentCount,
    int lateCount,
    String attendancePct,
    AttendanceState state,
  ) {
    if (isLoading && !hasData && !isEmpty) {
      return const AttendanceShimmer();
    }

    if (error && !hasData && !isEmpty) {
      return AttendanceErrorView(
        message: (state as AttendanceError).message,
        onRetry: _onRefresh,
      );
    }

    if ((isEmpty || (hasData && attendances.isEmpty)) && !isLoading) {
      return AttendanceEmptyView(
        title: l10n.noAttendanceHistory,
        subtitle: l10n.noAttendanceRecordsForUser,
        onRetry: _onRefresh,
      );
    }

    if (!hasData) {
      return const AttendanceShimmer();
    }

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: TahfeezColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              AttendanceSummaryCard(
                icon: Icons.check_circle_outline,
                label: l10n.attendancePercent,
                value: '$attendancePct%',
                iconBgColor: AttendanceStatus.present.statusColor.withOpacity(0.1),
                iconColor: AttendanceStatus.present.statusColor,
                valueColor: AttendanceStatus.present.statusColor,
              ),
              AttendanceSummaryCard(
                icon: Icons.person_outline,
                label: l10n.presentCount,
                value: '$presentCount',
                iconBgColor: AttendanceStatus.present.statusColor.withOpacity(0.1),
                iconColor: AttendanceStatus.present.statusColor,
                valueColor: AttendanceStatus.present.statusColor,
              ),
              AttendanceSummaryCard(
                icon: Icons.cancel_outlined,
                label: l10n.absentCount,
                value: '$absentCount',
                iconBgColor: AttendanceStatus.absent.statusColor.withOpacity(0.1),
                iconColor: AttendanceStatus.absent.statusColor,
                valueColor: AttendanceStatus.absent.statusColor,
              ),
              AttendanceSummaryCard(
                icon: Icons.access_time,
                label: AttendanceStatus.late.localizedName(l10n),
                value: '$lateCount',
                iconBgColor: AttendanceStatus.late.statusColor.withOpacity(0.1),
                iconColor: AttendanceStatus.late.statusColor,
                valueColor: AttendanceStatus.late.statusColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          AttendanceCalendar(
            month: currentMonth,
            attendances: attendances,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.timeline,
            style: TahfeezTextStyles.titleLg.copyWith(
              color: TahfeezColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...attendances.reversed.toList().asMap().entries.map(
            (entry) => AttendanceTimelineTile(
              attendance: entry.value,
              isLast: entry.key == attendances.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/enums/attendance_status.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../widgets/attendance_shimmer.dart';
import '../widgets/attendance_error_view.dart';
import '../widgets/attendance_empty_view.dart';
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

  @override
  Widget build(BuildContext context) {
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
          'Attendance History',
          style: TahfeezTextStyles.headlineLg.copyWith(
            color: TahfeezColors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listenWhen: (previous, current) => current is AttendanceError,
        listener: (context, state) {
          if (state is AttendanceError) {
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
        title: 'No attendance history',
        subtitle: 'No attendance records found for this user.',
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
                label: 'Attendance %',
                value: '$attendancePct%',
                iconBgColor: AttendanceStatus.present.statusColor.withOpacity(0.1),
                iconColor: AttendanceStatus.present.statusColor,
                valueColor: AttendanceStatus.present.statusColor,
              ),
              AttendanceSummaryCard(
                icon: Icons.person_outline,
                label: 'Present',
                value: '$presentCount',
                iconBgColor: AttendanceStatus.present.statusColor.withOpacity(0.1),
                iconColor: AttendanceStatus.present.statusColor,
                valueColor: AttendanceStatus.present.statusColor,
              ),
              AttendanceSummaryCard(
                icon: Icons.cancel_outlined,
                label: 'Absent',
                value: '$absentCount',
                iconBgColor: AttendanceStatus.absent.statusColor.withOpacity(0.1),
                iconColor: AttendanceStatus.absent.statusColor,
                valueColor: AttendanceStatus.absent.statusColor,
              ),
              AttendanceSummaryCard(
                icon: Icons.access_time,
                label: 'Late',
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
            'Timeline',
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

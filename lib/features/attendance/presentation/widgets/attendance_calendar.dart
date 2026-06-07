import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/enums/attendance_status.dart';

class AttendanceCalendar extends StatelessWidget {
  final DateTime month;
  final List<Attendance> attendances;
  final ValueChanged<DateTime>? onDayTap;

  const AttendanceCalendar({
    super.key,
    required this.month,
    required this.attendances,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstWeekday = DateTime(month.year, month.month, 1).weekday % 7;
    final attendanceByDay = <int, AttendanceStatus>{};
    for (final a in attendances) {
      if (a.date.year == month.year && a.date.month == month.month) {
        attendanceByDay[a.date.day] = a.status;
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TahfeezColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TahfeezColors.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _monthLabel(month),
                style: TahfeezTextStyles.titleLg.copyWith(
                  color: TahfeezColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${month.year}',
                style: TahfeezTextStyles.bodyMd.copyWith(
                  color: TahfeezColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: daysInMonth + firstWeekday,
            itemBuilder: (context, index) {
              if (index < firstWeekday) {
                return const SizedBox.shrink();
              }
              final day = index - firstWeekday + 1;
              final status = attendanceByDay[day];
              return _DayCell(
                day: day,
                status: status,
                onTap: onDayTap != null
                    ? () => onDayTap!(
                          DateTime(month.year, month.month, day),
                        )
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }

  String _monthLabel(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[date.month - 1];
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final AttendanceStatus? status;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: status != null
            ? BoxDecoration(
                color: status!.statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              )
            : null,
        child: Center(
          child: Text(
            '$day',
            style: TahfeezTextStyles.labelMd.copyWith(
              color: status?.statusColor ?? TahfeezColors.onSurfaceVariant,
              fontWeight: status != null ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

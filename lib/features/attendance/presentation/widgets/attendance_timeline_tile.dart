import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../domain/entities/attendance.dart';
import 'attendance_status_chip.dart';

class AttendanceTimelineTile extends StatelessWidget {
  final Attendance attendance;
  final bool isLast;

  const AttendanceTimelineTile({
    super.key,
    required this.attendance,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: attendance.status.statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: TahfeezColors.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: TahfeezColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: TahfeezColors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _formatDate(attendance.date),
                        style: TahfeezTextStyles.titleLg.copyWith(
                          color: TahfeezColors.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      AttendanceStatusChip(status: attendance.status),
                    ],
                  ),
                  if (attendance.notes != null &&
                      attendance.notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      attendance.notes!,
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: TahfeezColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

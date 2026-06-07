import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../domain/enums/attendance_status.dart';

class AttendanceStatusDropdown extends StatelessWidget {
  final AttendanceStatus? value;
  final ValueChanged<AttendanceStatus?> onChanged;
  final bool compact;

  const AttendanceStatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: compact ? const EdgeInsets.symmetric(horizontal: 4) : null,
      decoration: compact
          ? BoxDecoration(
              color: TahfeezColors.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AttendanceStatus>(
          value: value,
          isDense: compact,
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
              : EdgeInsets.zero,
          borderRadius: BorderRadius.circular(12),
          hint: Text(
            'Status',
            style: TahfeezTextStyles.bodyMd.copyWith(
              color: TahfeezColors.onSurfaceVariant,
            ),
          ),
          items: AttendanceStatus.values.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Text(
                s.displayName,
                style: TahfeezTextStyles.bodyMd.copyWith(
                  color: s.statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

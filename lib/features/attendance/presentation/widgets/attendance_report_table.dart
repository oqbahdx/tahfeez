import 'package:flutter/material.dart';
import '../../../../theme/tahfeez_theme.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/enums/attendance_status.dart';

class AttendanceReportTable extends StatelessWidget {
  final List<Attendance> attendances;

  const AttendanceReportTable({
    super.key,
    required this.attendances,
  });

  @override
  Widget build(BuildContext context) {
    final summary = _buildSummary();
    if (summary.isEmpty) {
      return Center(
        child: Text(
          'No attendance data',
          style: TahfeezTextStyles.bodyMd.copyWith(
            color: TahfeezColors.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: TahfeezColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: TahfeezColors.outlineVariant),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  TahfeezColors.surfaceContainer,
                ),
                columns: const [
                  DataColumn(label: Text('Student')),
                  DataColumn(label: Text('Present'), numeric: true),
                  DataColumn(label: Text('Absent'), numeric: true),
                  DataColumn(label: Text('Late'), numeric: true),
                  DataColumn(label: Text('%'), numeric: true),
                ],
                rows: summary.entries.map((entry) {
                  final s = entry.value;
                  final total = s.present + s.absent + s.late;
                  final pct = total > 0 ? (s.present / total * 100) : 0.0;
                  return DataRow(cells: [
                    DataCell(Text(
                      entry.key,
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: TahfeezColors.onSurface,
                      ),
                    )),
                    DataCell(Text(
                      '${s.present}',
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: AttendanceStatus.present.statusColor,
                      ),
                    )),
                    DataCell(Text(
                      '${s.absent}',
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: AttendanceStatus.absent.statusColor,
                      ),
                    )),
                    DataCell(Text(
                      '${s.late}',
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: AttendanceStatus.late.statusColor,
                      ),
                    )),
                    DataCell(Text(
                      '${pct.toStringAsFixed(1)}%',
                      style: TahfeezTextStyles.bodyMd.copyWith(
                        color: TahfeezColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Map<String, _StudentSummary> _buildSummary() {
    final map = <String, _StudentSummary>{};
    for (final a in attendances) {
      final name = a.userName ?? a.userId;
      final s = map.putIfAbsent(
        name,
        () => _StudentSummary(),
      );
      switch (a.status) {
        case AttendanceStatus.present:
          s.present++;
        case AttendanceStatus.absent:
          s.absent++;
        case AttendanceStatus.late:
          s.late++;
      }
    }
    return map;
  }
}

class _StudentSummary {
  int present = 0;
  int absent = 0;
  int late = 0;
}

import 'package:flutter/material.dart';

enum AttendanceStatus {
  present(1),
  absent(2),
  late(3);

  final int value;
  const AttendanceStatus(this.value);

  static AttendanceStatus fromApi(int value) {
    return AttendanceStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => AttendanceStatus.present,
    );
  }

  int toApi() => value;

  String get displayName {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
    }
  }

  Color get statusColor {
    switch (this) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.late:
        return Colors.orange;
    }
  }
}

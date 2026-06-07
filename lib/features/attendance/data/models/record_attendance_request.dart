import '../../domain/enums/attendance_status.dart';

class RecordAttendanceRequest {
  final String userId;
  final DateTime date;
  final AttendanceStatus status;
  final String? notes;

  const RecordAttendanceRequest({
    required this.userId,
    required this.date,
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': _formatDate(date),
      'status': status.toApi(),
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

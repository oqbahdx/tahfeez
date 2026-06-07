import '../../domain/enums/attendance_status.dart';

class UpdateAttendanceRequest {
  final AttendanceStatus status;
  final String? notes;

  const UpdateAttendanceRequest({
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status.toApi(),
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}

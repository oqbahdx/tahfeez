import '../../domain/enums/attendance_status.dart';
import '../../domain/entities/attendance.dart';

class AttendanceDto extends Attendance {
  const AttendanceDto({
    required super.id,
    required super.userId,
    super.userName,
    required super.date,
    required super.status,
    super.notes,
  });

  factory AttendanceDto.fromJson(Map<String, dynamic> json) {
    return AttendanceDto(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String?,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      status: AttendanceStatus.fromApi((json['status'] as int?) ?? 1),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'date': formatDate(date),
      'status': status.toApi(),
      'notes': notes,
    };
  }

  AttendanceDto copyWith({
    String? id,
    String? userId,
    String? userName,
    DateTime? date,
    AttendanceStatus? status,
    String? notes,
  }) {
    return AttendanceDto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      date: date ?? this.date,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

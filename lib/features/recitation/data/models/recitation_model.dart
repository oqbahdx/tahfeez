import '../../domain/enums/recitation_type.dart';
import '../../domain/entities/recitation.dart';

class RecitationModel extends Recitation {
  const RecitationModel({
    required super.id,
    required super.studentId,
    super.studentName,
    required super.teacherId,
    super.teacherName,
    required super.date,
    required super.ayahsCount,
    required super.type,
    required super.grade,
    super.gradeLabel,
    super.notes,
  });

  factory RecitationModel.fromJson(Map<String, dynamic> json) {
    return RecitationModel(
      id: json['id'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      studentName: json['studentName'] as String?,
      teacherId: json['teacherId'] as String? ?? '',
      teacherName: json['teacherName'] as String?,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      ayahsCount: (json['ayahsCount'] as int?) ?? 0,
      type: RecitationType.fromInt((json['type'] as int?) ?? 1),
      grade: (json['grade'] as int?) ?? 1,
      gradeLabel: json['gradeLabel'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'date': formatDate(date),
      'ayahsCount': ayahsCount,
      'type': typeValue,
      'grade': grade,
      'gradeLabel': gradeLabel,
      'notes': notes,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'studentId': studentId,
      'teacherId': teacherId,
      'date': formatDate(date),
      'ayahsCount': ayahsCount,
      'type': typeValue,
      'grade': grade,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

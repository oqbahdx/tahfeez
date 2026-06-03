import 'package:equatable/equatable.dart';

class Recitation extends Equatable {
  final String id;
  final String studentId;
  final String? studentName;
  final String teacherId;
  final String? teacherName;
  final DateTime date;
  final int ayahsCount;
  final String type;
  final int grade;
  final String? gradeLabel;
  final String? notes;

  const Recitation({
    required this.id,
    required this.studentId,
    this.studentName,
    required this.teacherId,
    this.teacherName,
    required this.date,
    required this.ayahsCount,
    required this.type,
    required this.grade,
    this.gradeLabel,
    this.notes,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    studentName,
    teacherId,
    teacherName,
    date,
    ayahsCount,
    type,
    grade,
    gradeLabel,
    notes,
  ];
}

import 'package:equatable/equatable.dart';
import '../../domain/enums/recitation_type.dart';

abstract class RecitationEvent extends Equatable {
  const RecitationEvent();
  @override
  List<Object?> get props => [];
}

class LogRecitationEvent extends RecitationEvent {
  final String studentId;
  final String teacherId;
  final DateTime date;
  final int ayahsCount;
  final RecitationType type;
  final int grade;
  final String? notes;

  const LogRecitationEvent({
    required this.studentId,
    required this.teacherId,
    required this.date,
    required this.ayahsCount,
    required this.type,
    required this.grade,
    this.notes,
  });

  @override
  List<Object?> get props => [
    studentId, teacherId, date, ayahsCount, type, grade, notes,
  ];
}

class GetRecitationsByStudentEvent extends RecitationEvent {
  final String studentId;

  const GetRecitationsByStudentEvent(this.studentId);

  @override
  List<Object?> get props => [studentId];
}

class GetRecitationsByClassEvent extends RecitationEvent {
  final String classId;
  final String? month;

  const GetRecitationsByClassEvent({
    required this.classId,
    this.month,
  });

  @override
  List<Object?> get props => [classId, month];
}

class SetSelectedMonthEvent extends RecitationEvent {
  final String? month;

  const SetSelectedMonthEvent(this.month);

  @override
  List<Object?> get props => [month];
}

class ResetRecitationOperationStateEvent extends RecitationEvent {
  const ResetRecitationOperationStateEvent();
}

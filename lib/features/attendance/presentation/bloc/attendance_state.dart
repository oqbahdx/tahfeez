import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

class AttendanceLoaded extends AttendanceState {
  final List<Attendance> attendances;

  const AttendanceLoaded(this.attendances);

  @override
  List<Object?> get props => [attendances];
}

class AttendanceEmpty extends AttendanceState {
  const AttendanceEmpty();
}

class AttendanceSubmitting extends AttendanceState {
  const AttendanceSubmitting();
}

class AttendanceSuccess extends AttendanceState {
  final String message;

  const AttendanceSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentsLoaded extends StudentState {
  final List<User> students;
  final List<User> filteredStudents;
  final String searchQuery;

  const StudentsLoaded({
    required this.students,
    required this.filteredStudents,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [students, filteredStudents, searchQuery];
}

class StudentOperationLoading extends StudentState {
  const StudentOperationLoading();
}

class StudentOperationSuccess extends StudentState {
  final String message;
  const StudentOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class StudentError extends StudentState {
  final String message;

  const StudentError(this.message);

  @override
  List<Object?> get props => [message];
}

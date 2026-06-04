import 'package:equatable/equatable.dart';
import '../../domain/entities/class_entity.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ClassState extends Equatable {
  const ClassState();
  @override
  List<Object?> get props => [];
}

class ClassInitial extends ClassState {}

class ClassLoading extends ClassState {}

class ClassesLoaded extends ClassState {
  final List<ClassEntity> classes;
  final List<ClassEntity> filteredClasses;
  final String searchQuery;

  const ClassesLoaded({
    required this.classes,
    required this.filteredClasses,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [classes, filteredClasses, searchQuery];
}

class ClassLoaded extends ClassState {
  final ClassEntity classEntity;
  const ClassLoaded(this.classEntity);
  @override
  List<Object?> get props => [classEntity];
}

class ClassStudentsLoaded extends ClassState {
  final List<User> students;
  const ClassStudentsLoaded(this.students);
  @override
  List<Object?> get props => [students];
}

class UsersLoaded extends ClassState {
  final List<User> users;
  const UsersLoaded(this.users);
  @override
  List<Object?> get props => [users];
}

class ClassOperationSuccess extends ClassState {
  final String message;
  const ClassOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ClassOperationLoading extends ClassState {
  const ClassOperationLoading();
}

class ClassError extends ClassState {
  final String message;
  const ClassError(this.message);
  @override
  List<Object?> get props => [message];
}

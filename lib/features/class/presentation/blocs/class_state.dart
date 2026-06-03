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
  const ClassesLoaded(this.classes);
  @override
  List<Object?> get props => [classes];
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

class ClassOperationSuccess extends ClassState {
  final String message;
  const ClassOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ClassError extends ClassState {
  final String message;
  const ClassError(this.message);
  @override
  List<Object?> get props => [message];
}

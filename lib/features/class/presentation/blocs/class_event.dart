import 'package:equatable/equatable.dart';

abstract class ClassEvent extends Equatable {
  const ClassEvent();
  @override
  List<Object?> get props => [];
}

class GetAllClassesEvent extends ClassEvent {}

class RefreshClassesEvent extends ClassEvent {}

class GetClassByIdEvent extends ClassEvent {
  final String id;
  const GetClassByIdEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class GetClassStudentsEvent extends ClassEvent {
  final String classId;
  const GetClassStudentsEvent(this.classId);
  @override
  List<Object?> get props => [classId];
}

class CreateClassEvent extends ClassEvent {
  final String name;
  final int type;
  final int mode;
  final String? teacherId;
  final String? assistantId;
  final String? supervisorId;
  const CreateClassEvent({
    required this.name,
    required this.type,
    required this.mode,
    this.teacherId,
    this.assistantId,
    this.supervisorId,
  });
  @override
  List<Object?> get props => [
    name,
    type,
    mode,
    teacherId,
    assistantId,
    supervisorId,
  ];
}

class UpdateClassEvent extends ClassEvent {
  final String id;
  final String name;
  final int type;
  final int mode;
  const UpdateClassEvent({
    required this.id,
    required this.name,
    required this.type,
    required this.mode,
  });
  @override
  List<Object?> get props => [id, name, type, mode];
}

class DeleteClassEvent extends ClassEvent {
  final String id;
  const DeleteClassEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class AssignStaffEvent extends ClassEvent {
  final String classId;
  final String? teacherId;
  final String? assistantId;
  final String? supervisorId;
  const AssignStaffEvent({
    required this.classId,
    this.teacherId,
    this.assistantId,
    this.supervisorId,
  });
  @override
  List<Object?> get props => [classId, teacherId, assistantId, supervisorId];
}

class SearchClassesEvent extends ClassEvent {
  final String query;
  const SearchClassesEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class FetchUsersEvent extends ClassEvent {
  final String role;
  const FetchUsersEvent(this.role);
  @override
  List<Object?> get props => [role];
}

class ResetOperationStateEvent extends ClassEvent {
  const ResetOperationStateEvent();
}

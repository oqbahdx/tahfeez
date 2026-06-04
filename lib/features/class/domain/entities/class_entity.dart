import 'package:equatable/equatable.dart';
import '../enums/class_type.dart';
import '../enums/class_mode.dart';

class ClassEntity extends Equatable {
  final String id;
  final String name;
  final ClassType classType;
  final ClassMode classMode;
  final String? teacherId;
  final String? teacherName;
  final String? assistantId;
  final String? assistantName;
  final String? supervisorId;
  final String? supervisorName;
  final int studentCount;

  const ClassEntity({
    required this.id,
    required this.name,
    required this.classType,
    required this.classMode,
    this.teacherId,
    this.teacherName,
    this.assistantId,
    this.assistantName,
    this.supervisorId,
    this.supervisorName,
    this.studentCount = 0,
  });

  int get type => classType.value;
  int get mode => classMode.value;

  String get typeName => classType.displayName;
  String get modeName => classMode.displayName;

  @override
  List<Object?> get props => [
    id,
    name,
    classType,
    classMode,
    teacherId,
    teacherName,
    assistantId,
    assistantName,
    supervisorId,
    supervisorName,
    studentCount,
  ];
}

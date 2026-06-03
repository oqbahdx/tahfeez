import 'package:equatable/equatable.dart';

class ClassEntity extends Equatable {
  final String id;
  final String name;
  final int type;
  final int mode;
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
    required this.type,
    required this.mode,
    this.teacherId,
    this.teacherName,
    this.assistantId,
    this.assistantName,
    this.supervisorId,
    this.supervisorName,
    this.studentCount = 0,
  });

  String get typeName {
    switch (type) {
      case 1:
        return 'Boys';
      case 2:
        return 'Girls';
      default:
        return 'Unknown';
    }
  }

  String get modeName {
    switch (mode) {
      case 1:
        return 'Online';
      case 2:
        return 'Offline';
      default:
        return 'Unknown';
    }
  }

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    mode,
    teacherId,
    teacherName,
    assistantId,
    assistantName,
    supervisorId,
    supervisorName,
    studentCount,
  ];
}

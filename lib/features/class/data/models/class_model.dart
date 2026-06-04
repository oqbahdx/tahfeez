import '../../domain/enums/class_type.dart';
import '../../domain/enums/class_mode.dart';
import '../../domain/entities/class_entity.dart';

class ClassModel extends ClassEntity {
  const ClassModel({
    required super.id,
    required super.name,
    required super.classType,
    required super.classMode,
    super.teacherId,
    super.teacherName,
    super.assistantId,
    super.assistantName,
    super.supervisorId,
    super.supervisorName,
    super.studentCount,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      classType: ClassType.fromInt((json['type'] as int?) ?? 0),
      classMode: ClassMode.fromInt((json['mode'] as int?) ?? 0),
      teacherId: json['teacherId'] as String?,
      teacherName: json['teacherName'] as String?,
      assistantId: json['assistantId'] as String?,
      assistantName: json['assistantName'] as String?,
      supervisorId: json['supervisorId'] as String?,
      supervisorName: json['supervisorName'] as String?,
      studentCount: (json['studentCount'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'mode': mode,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'assistantId': assistantId,
      'assistantName': assistantName,
      'supervisorId': supervisorId,
      'supervisorName': supervisorName,
      'studentCount': studentCount,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'name': name,
      'type': type,
      'mode': mode,
      'teacherId': teacherId,
      'assistantId': assistantId,
      'supervisorId': supervisorId,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {'name': name, 'type': type, 'mode': mode};
  }

  Map<String, dynamic> toStaffJson() {
    return {
      'teacherId': teacherId,
      'assistantId': assistantId,
      'supervisorId': supervisorId,
    };
  }
}

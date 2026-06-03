import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/class_entity.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ClassRepository {
  Future<Either<Failure, List<ClassEntity>>> getAllClasses();
  Future<Either<Failure, ClassEntity>> getClassById(String id);
  Future<Either<Failure, List<User>>> getClassStudents(String classId);
  Future<Either<Failure, String>> createClass({
    required String name,
    required int type,
    required int mode,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  });
  Future<Either<Failure, ClassEntity>> updateClass({
    required String id,
    required String name,
    required int type,
    required int mode,
  });
  Future<Either<Failure, void>> deleteClass(String id);
  Future<Either<Failure, ClassEntity>> assignStaff({
    required String classId,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  });
}

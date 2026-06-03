import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/class_entity.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/class_repository.dart';

class GetAllClassesUseCase {
  final ClassRepository repository;

  GetAllClassesUseCase(this.repository);

  Future<Either<Failure, List<ClassEntity>>> call() {
    return repository.getAllClasses();
  }
}

class GetClassByIdUseCase {
  final ClassRepository repository;

  GetClassByIdUseCase(this.repository);

  Future<Either<Failure, ClassEntity>> call(String id) {
    return repository.getClassById(id);
  }
}

class GetClassStudentsUseCase {
  final ClassRepository repository;

  GetClassStudentsUseCase(this.repository);

  Future<Either<Failure, List<User>>> call(String classId) {
    return repository.getClassStudents(classId);
  }
}

class CreateClassUseCase {
  final ClassRepository repository;

  CreateClassUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String name,
    required int type,
    required int mode,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  }) {
    return repository.createClass(
      name: name,
      type: type,
      mode: mode,
      teacherId: teacherId,
      assistantId: assistantId,
      supervisorId: supervisorId,
    );
  }
}

class UpdateClassUseCase {
  final ClassRepository repository;

  UpdateClassUseCase(this.repository);

  Future<Either<Failure, ClassEntity>> call({
    required String id,
    required String name,
    required int type,
    required int mode,
  }) {
    return repository.updateClass(id: id, name: name, type: type, mode: mode);
  }
}

class DeleteClassUseCase {
  final ClassRepository repository;

  DeleteClassUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteClass(id);
  }
}

class AssignStaffUseCase {
  final ClassRepository repository;

  AssignStaffUseCase(this.repository);

  Future<Either<Failure, ClassEntity>> call({
    required String classId,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  }) {
    return repository.assignStaff(
      classId: classId,
      teacherId: teacherId,
      assistantId: assistantId,
      supervisorId: supervisorId,
    );
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/class_entity.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasources/class_remote_datasource.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remoteDataSource;

  ClassRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ClassEntity>>> getAllClasses() async {
    try {
      final result = await remoteDataSource.getAllClasses();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ClassEntity>> getClassById(String id) async {
    try {
      final result = await remoteDataSource.getClassById(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getClassStudents(String classId) async {
    try {
      final result = await remoteDataSource.getClassStudents(classId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> createClass({
    required String name,
    required int type,
    required int mode,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  }) async {
    try {
      final id = await remoteDataSource.createClass(
        name: name,
        type: type,
        mode: mode,
        teacherId: teacherId,
        assistantId: assistantId,
        supervisorId: supervisorId,
      );
      return Right(id);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ClassEntity>> updateClass({
    required String id,
    required String name,
    required int type,
    required int mode,
  }) async {
    try {
      final result = await remoteDataSource.updateClass(
        id: id,
        name: name,
        type: type,
        mode: mode,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteClass(String id) async {
    try {
      await remoteDataSource.deleteClass(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ClassEntity>> assignStaff({
    required String classId,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  }) async {
    try {
      final result = await remoteDataSource.assignStaff(
        classId: classId,
        teacherId: teacherId,
        assistantId: assistantId,
        supervisorId: supervisorId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}

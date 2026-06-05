import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';

abstract class StudentRepository {
  Future<Either<Failure, List<User>>> getStudents();
}

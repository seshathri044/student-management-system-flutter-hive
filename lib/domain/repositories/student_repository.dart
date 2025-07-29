
// lib/domain/repositories/student_repository.dart
import '../../core/entities/student_entity.dart';
import '../../core/error/failures.dart';
import '../../core/utils/result.dart';

abstract class StudentRepository {
  Future<Result<List<StudentEntity>>> getStudentsByClass(String className);
  Future<Result<StudentEntity>> addStudent(StudentEntity student);
  Future<Result<StudentEntity>> updateStudent(StudentEntity student);
  Future<Result<void>> deleteStudent(String studentId);
  Future<Result<bool>> isRollNumberExists(String className, int rollNumber, {String? excludeStudentId});
}
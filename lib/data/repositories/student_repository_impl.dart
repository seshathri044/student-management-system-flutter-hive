
// lib/data/repositories/student_repository_impl.dart
import '../../core/entities/student_entity.dart';
import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_local_datasource.dart';
import '../models/student_model.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentLocalDataSource localDataSource;

  StudentRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<List<StudentEntity>>> getStudentsByClass(String className) async {
    try {
      final students = await localDataSource.getStudentsByClass(className);
      final entities = students.map((student) => student.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return Error(DatabaseFailure('Failed to get students: ${e.toString()}'));
    }
  }

  @override
  Future<Result<StudentEntity>> addStudent(StudentEntity student) async {
    try {
      // Validate input
      if (student.name.trim().isEmpty) {
        return const Error(ValidationFailure('Student name cannot be empty'));
      }
      
      if (student.age <= 0) {
        return const Error(ValidationFailure('Age must be greater than 0'));
      }
      
      if (student.rollNumber <= 0) {
        return const Error(ValidationFailure('Roll number must be greater than 0'));
      }

      // Check for duplicate roll number
      final rollExists = await localDataSource.isRollNumberExists(
        student.className, 
        student.rollNumber
      );
      
      if (rollExists) {
        return const Error(DuplicateFailure('Roll number already exists in this class'));
      }

      final studentModel = StudentModel.fromEntity(student);
      final savedStudent = await localDataSource.addStudent(studentModel);
      
      return Success(savedStudent.toEntity());
    } catch (e) {
      return Error(DatabaseFailure('Failed to add student: ${e.toString()}'));
    }
  }

  @override
  Future<Result<StudentEntity>> updateStudent(StudentEntity student) async {
    try {
      // Validate input
      if (student.name.trim().isEmpty) {
        return const Error(ValidationFailure('Student name cannot be empty'));
      }
      
      if (student.age <= 0) {
        return const Error(ValidationFailure('Age must be greater than 0'));
      }
      
      if (student.rollNumber <= 0) {
        return const Error(ValidationFailure('Roll number must be greater than 0'));
      }

      // Check for duplicate roll number (excluding current student)
      final rollExists = await localDataSource.isRollNumberExists(
        student.className, 
        student.rollNumber,
        excludeStudentId: student.id
      );
      
      if (rollExists) {
        return const Error(DuplicateFailure('Roll number already exists in this class'));
      }

      final studentModel = StudentModel.fromEntity(student);
      final updatedStudent = await localDataSource.updateStudent(studentModel);
      
      return Success(updatedStudent.toEntity());
    } catch (e) {
      return Error(DatabaseFailure('Failed to update student: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> deleteStudent(String studentId) async {
    try {
      await localDataSource.deleteStudent(studentId);
      return const Success(null);
    } catch (e) {
      return Error(DatabaseFailure('Failed to delete student: ${e.toString()}'));
    }
  }

  @override
  Future<Result<bool>> isRollNumberExists(String className, int rollNumber, {String? excludeStudentId}) async {
    try {
      final exists = await localDataSource.isRollNumberExists(
        className, 
        rollNumber, 
        excludeStudentId: excludeStudentId
      );
      return Success(exists);
    } catch (e) {
      return Error(DatabaseFailure('Failed to check roll number: ${e.toString()}'));
    }
  }
}
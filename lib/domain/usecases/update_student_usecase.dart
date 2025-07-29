
// lib/domain/usecases/update_student_usecase.dart
import '../../core/entities/student_entity.dart';
import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../repositories/student_repository.dart';

class UpdateStudentUseCase {
  final StudentRepository repository;

  UpdateStudentUseCase({required this.repository});

  Future<Result<StudentEntity>> call(UpdateStudentParams params) async {
    // Business logic validation
    if (params.id.trim().isEmpty) {
      return const Error(ValidationFailure('Student ID is required for update'));
    }

    if (params.name.trim().isEmpty) {
      return const Error(ValidationFailure('Student name is required'));
    }

    if (params.age < 5 || params.age > 25) {
      return const Error(ValidationFailure('Age must be between 5 and 25'));
    }

    if (params.rollNumber < 1 || params.rollNumber > 999) {
      return const Error(ValidationFailure('Roll number must be between 1 and 999'));
    }

    if (!['Present', 'Absent'].contains(params.attendance)) {
      return const Error(ValidationFailure('Invalid attendance status'));
    }

    final student = StudentEntity(
      id: params.id,
      name: params.name.trim(),
      age: params.age,
      rollNumber: params.rollNumber,
      attendance: params.attendance,
      className: params.className,
    );

    return await repository.updateStudent(student);
  }
}

class UpdateStudentParams {
  final String id;
  final String name;
  final int age;
  final int rollNumber;
  final String attendance;
  final String className;

  UpdateStudentParams({
    required this.id,
    required this.name,
    required this.age,
    required this.rollNumber,
    required this.attendance,
    required this.className,
  });
}
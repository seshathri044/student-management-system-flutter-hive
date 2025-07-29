
// lib/domain/usecases/add_student_usecase.dart
import '../../core/entities/student_entity.dart';
import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../repositories/student_repository.dart';

class AddStudentUseCase {
  final StudentRepository repository;

  AddStudentUseCase({required this.repository});

  Future<Result<StudentEntity>> call(AddStudentParams params) async {
    // Additional business logic validation can be added here
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
      id: params.id ?? '',
      name: params.name.trim(),
      age: params.age,
      rollNumber: params.rollNumber,
      attendance: params.attendance,
      className: params.className,
    );

    return await repository.addStudent(student);
  }
}

class AddStudentParams {
  final String? id;
  final String name;
  final int age;
  final int rollNumber;
  final String attendance;
  final String className;

  AddStudentParams({
    this.id,
    required this.name,
    required this.age,
    required this.rollNumber,
    required this.attendance,
    required this.className,
  });
}
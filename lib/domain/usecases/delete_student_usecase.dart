
// lib/domain/usecases/delete_student_usecase.dart
import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../repositories/student_repository.dart';

class DeleteStudentUseCase {
  final StudentRepository repository;

  DeleteStudentUseCase({required this.repository});

  Future<Result<void>> call(String studentId) async {
    if (studentId.trim().isEmpty) {
      return const Error(ValidationFailure('Student ID is required'));
    }

    return await repository.deleteStudent(studentId);
  }
}

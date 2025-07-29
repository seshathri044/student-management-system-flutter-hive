// lib/domain/usecases/get_students_by_class_usecase.dart
import '../../core/entities/student_entity.dart';
import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../repositories/student_repository.dart';

class GetStudentsByClassUseCase {
  final StudentRepository repository;

  GetStudentsByClassUseCase({required this.repository});

  Future<Result<List<StudentEntity>>> call(String className) async {
    if (className.trim().isEmpty) {
      return const Error(ValidationFailure('Class name cannot be empty'));
    }
    
    return await repository.getStudentsByClass(className);
  }
}

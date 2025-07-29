
// lib/domain/usecases/check_roll_number_exists_usecase.dart
import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../repositories/student_repository.dart';

class CheckRollNumberExistsUseCase {
  final StudentRepository repository;

  CheckRollNumberExistsUseCase({required this.repository});

  Future<Result<bool>> call(CheckRollNumberParams params) async {
    if (params.className.trim().isEmpty) {
      return const Error(ValidationFailure('Class name is required'));
    }

    if (params.rollNumber < 1) {
      return const Error(ValidationFailure('Roll number must be greater than 0'));
    }

    return await repository.isRollNumberExists(
      params.className,
      params.rollNumber,
      excludeStudentId: params.excludeStudentId,
    );
  }
}

class CheckRollNumberParams {
  final String className;
  final int rollNumber;
  final String? excludeStudentId;

  CheckRollNumberParams({
    required this.className,
    required this.rollNumber,
    this.excludeStudentId,
  });
}
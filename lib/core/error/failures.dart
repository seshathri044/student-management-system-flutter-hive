
// lib/core/error/failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class DuplicateFailure extends Failure {
  const DuplicateFailure(super.message);
}
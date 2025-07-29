
// lib/core/utils/result.dart
import 'package:student_management_system_flutter/core/error/failures.dart';

abstract class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);
}

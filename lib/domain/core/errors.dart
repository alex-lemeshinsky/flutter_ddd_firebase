import 'package:flutter_ddd_firebase/domain/core/failures.dart';

class NotAuthenticatedError extends Error {}

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    return Error.safeToString(
      "Encountered a ValueFailure at an unrecoverable point. Terminating. Failure was: $valueFailure",
    );
  }
}

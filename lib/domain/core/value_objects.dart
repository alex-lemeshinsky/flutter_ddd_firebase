import 'package:dartz/dartz.dart';
import 'package:flutter_ddd_firebase/domain/core/errors.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  bool isValid() => value.isRight();

  /// Throws [UnexpectedValueError] containing the [ValueFailure]
  T getOrCrash() {
    return value.fold((l) => throw UnexpectedValueError(l), id);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueObject<T> && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => "ValueObject($value)";
}

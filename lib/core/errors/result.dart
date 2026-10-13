import 'package:fpdart/fpdart.dart';

import 'failures.dart';

/// Standard domain result: `Either<AppFailure, T>`.
///
/// Right = success, Left = typed failure. Never throw for expected
/// business-rule violations (insufficient stock, duplicates, validation);
/// throw only for programmer errors.
typedef Result<T> = Either<AppFailure, T>;

/// Convenience constructors.
Result<T> ok<T>(T value) => Right(value);
Result<T> fail<T>(AppFailure failure) => Left(failure);

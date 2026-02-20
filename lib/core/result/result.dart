sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T value) success,
    required R Function(Exception error) failure,
  });
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);

  @override
  R when<R>({
    required R Function(T value) success,
    required R Function(Exception error) failure,
  }) {
    return success(value);
  }
}

class Failure<T> extends Result<T> {
  final Exception error;
  const Failure(this.error);

  @override
  R when<R>({
    required R Function(T value) success,
    required R Function(Exception error) failure,
  }) {
    return failure(error);
  }
}
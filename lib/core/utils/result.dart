class Result<T> {
  final T? data;
  final String? error;

  const Result._({this.data, this.error});

  bool get isSuccess => data != null;

  bool get isFailure => error != null;

  factory Result.success(T data) => Result._(data: data);

  factory Result.failure(String? error) => Result._(error: error);

  /// Force to handle both cases
  R when<R>({
    required R Function(T data) success,
    required R Function(String error) failure,
  }) {
    if (isSuccess && data != null) {
      return success(data as T);
    }
    return failure(error ?? 'Unknown error');
  }

  /// Only called if data or error is present, otherwise [orElse]
  R maybeWhen<R>({
    R Function(T data)? success,
    R Function(String error)? failure,
    required R Function() orElse,
  }) {
    if (isSuccess && data != null) {
      return success != null ? success(data as T) : orElse();
    }
    if (isFailure && error != null) {
      return failure != null ? failure(error!) : orElse();
    }
    return orElse();
  }

  /// Result mapper
  Result<R> map<R>(R Function(T data) convert) {
    if (isSuccess && data != null) {
      return Result.success(convert(data as T));
    }
    return Result.failure(error ?? 'Unknown error');
  }
}

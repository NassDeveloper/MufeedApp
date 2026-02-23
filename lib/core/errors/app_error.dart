sealed class AppError {
  const AppError(this.message, {this.debugInfo});

  final String message;
  final String? debugInfo;

  @override
  String toString() => 'AppError($runtimeType): $message';
}

class DatabaseError extends AppError {
  const DatabaseError(super.message, {super.debugInfo});
}

class ContentError extends AppError {
  const ContentError(super.message, {super.debugInfo});
}

class TtsError extends AppError {
  const TtsError(super.message, {super.debugInfo});
}

class AnalyticsError extends AppError {
  const AnalyticsError(super.message, {super.debugInfo});
}

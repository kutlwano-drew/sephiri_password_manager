class AppException implements Exception {
  const AppException(this.message);
  final String message;
  @override
  String toString() => message;
}

class InvalidPasswordException extends AppException {
  const InvalidPasswordException() : super('Incorrect master password.');
}

class InvalidBackupException extends AppException {
  const InvalidBackupException() : super('The backup is invalid, corrupted, or incompatible.');
}

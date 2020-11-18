class AuthException implements Exception {
  final String _message;
  final String _statusCode;

  AuthException(this._message, this._statusCode);

  @override
  String toString() {
    return "AuthError ($_statusCode): $_message.";
  }
}

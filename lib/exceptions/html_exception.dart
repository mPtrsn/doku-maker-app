class HtmlException implements Exception {
  final String _message;
  final String _statusCode;

  HtmlException(this._message, this._statusCode);

  @override
  String toString() {
    return "HtmlException ($_statusCode): $_message.";
  }
}

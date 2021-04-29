class ErrorException implements Exception {
  final _message;
  final _prefix;

  ErrorException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends ErrorException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends ErrorException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends ErrorException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends ErrorException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}


import 'handled_response.dart';

typedef ResponseErrorFactory = ResponseError Function({
  String friendlyMessage,
  String error,
});

class ResponseError extends HandledResponse {
  const ResponseError._(
    int code, {
    super.friendlyMessage = '',
    super.error = '',
  })  : assert(code < 200 || code > 204),
        super(code);

  factory ResponseError.fromCode(
    int code, {
    String friendlyMessage = '',
    String error = '',
  }) {
    ResponseError Function({
      String friendlyMessage,
      String error,
    })? constructor;
    constructor = {
      403: ForbiddenError.new,
      404: NotFoundError.new,
      503: HostUnavailableError.new,
      401: UserNotAuthorized.new,
      402: ValidationError.new,
      406: NotAcceptableError.new,
    }[code];
    if (constructor != null) {
      return constructor.call(error: error, friendlyMessage: friendlyMessage);
    }
    return UnknownError(code: code, friendlyMessage: friendlyMessage, error: error);
  }
}

extension HandledResponseExtension on HandledResponse {
  HandledResponse get asSuccessful {
    assert(isSuccess, 'Response is not successful');
    return this;
  }

  ResponseError get asError {
    assert(!isSuccess, 'Response is successful');
    assert(this is ResponseError, 'Response is not an error');
    return this as ResponseError;
  }
}

class ForbiddenError extends ResponseError {
  const ForbiddenError({
    super.friendlyMessage = '',
    super.error = '',
  }) : super._(403);
}

class NotFoundError extends ResponseError {
  const NotFoundError({
    super.friendlyMessage = '',
    super.error = '',
  }) : super._(404);
}

class HostUnavailableError extends ResponseError {
  const HostUnavailableError({
    super.friendlyMessage = '',
    super.error = '',
  }) : super._(503);
}

class UserNotAuthorized extends ResponseError {
  const UserNotAuthorized({
    super.friendlyMessage = '',
    super.error = '',
  }) : super._(401);
}

class ValidationError extends ResponseError {
  const ValidationError({
    super.friendlyMessage = '',
    super.error = '',
  }) : super._(402);
}

class NotAcceptableError extends ResponseError {
  const NotAcceptableError({
    super.friendlyMessage = '',
    super.error = '',
  }) : super._(406);
}

class UnknownError extends ResponseError {
  const UnknownError({
    int? code,
    super.friendlyMessage = '',
    super.error = '',
  }) : super._(code ?? 0);
}

import '../response/response_error.dart';
import '../response/server_response.dart';

typedef HttpErrorHandlerFunction = void Function(ResponseError responseError);
typedef HttpErrorHandlers = Map<Type, HttpErrorHandlerFunction>;

class HttpErrorHandler {
  final HttpErrorHandlerFunction? _defaultErrorHandler;
  final HttpErrorHandlers? _defaultErrorHandlers;

  const HttpErrorHandler({
    HttpErrorHandlerFunction? defaultErrorHandler,
    HttpErrorHandlers? defaultErrorHandlers,
  })  : _defaultErrorHandler = defaultErrorHandler,
        _defaultErrorHandlers = defaultErrorHandlers;

  void tryHandleResponse(
      ServerResponse response, {
        HttpErrorHandlers? errorHandlers,
      }) {
    if (response.isSuccess) {
      return;
    }
    handleError(
      response as ResponseError,
      errorHandlers: errorHandlers,
    );
  }

  void handleError(
      ResponseError response, {
        HttpErrorHandlers? errorHandlers,
      }) {
    final handler = errorHandlers?[response.runtimeType] ??
        _defaultErrorHandlers?[response.runtimeType] ??
        _defaultErrorHandler;
    handler?.call(response);
  }
}
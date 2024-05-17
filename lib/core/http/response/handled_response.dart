import 'dart:io';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'response_error.dart';
import 'server_response.dart';

@immutable
class HandledResponse extends ServerResponse {
  final String friendlyMessage;
  final String error;

  const HandledResponse(
    int code, {
    this.friendlyMessage = '',
    this.error = '',
    Map<String, dynamic>? data,
  }) : super(code, data: data);

  factory HandledResponse.fromDioException(DioException dioError) {
    if (dioError.error is SocketException) {
      return const HostUnavailableError();
    }
    if (dioError.response == null) {
      return UnknownError(error: dioError.error.toString());
    }
    return HandledResponse.fromDioResult(
      dioError.response!,
    );
  }

  factory HandledResponse.noContent() => const HandledResponse(204);

  factory HandledResponse.fromDioResult(
    Response dioResponse,
  ) {
    HandledResponse response;
    if (dioResponse.data == null) {
      response = HandledResponse(
        dioResponse.statusCode ?? 0,
      );
    } else if (dioResponse.data is Map<String, dynamic>) {
      response = HandledResponse(
        dioResponse.statusCode ?? 0,
        data: dioResponse.data,
      );
    } else {
      response = HandledResponse(
        dioResponse.statusCode ?? 0,
        data: {'data': dioResponse.data},
      );
    }
    if (response.isSuccess) {
      return response;
    }
    final data = response.data;
    return ResponseError.fromCode(
      dioResponse.statusCode ?? 0,
      error: data?['error']?.toString() ?? '',
    );
  }

  factory HandledResponse.fromException(Exception exception) {
    if (exception is DioException) {
      return HandledResponse.fromDioException(exception);
    }

    return HandledResponse(
      0,
      error: exception.toString(),
    );
  }
}

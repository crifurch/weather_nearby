import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'handled_response.dart';
import 'server_response.dart';

@immutable
class ComplexResponse<T> extends HandledResponse {
  final T? castedData;

  ComplexResponse(HandledResponse response, {this.castedData})
      : super(
          response.code,
          friendlyMessage: response.friendlyMessage,
          error: response.error,
          data: response.data,
        );

  ComplexResponse.converted(
    HandledResponse response, {
    T? Function(Map<String, dynamic> data)? converter,
  }) : this(
          response,
          castedData: response.data != null ? converter?.call(response.data!) : null,
        );

  ComplexResponse.fromDioException(DioException dioError) : this(HandledResponse.fromDioException(dioError));

  ComplexResponse.fromDioResult(
    Response<Map<String, dynamic>> dioResponse, {
    T? Function(Map<String, dynamic> data)? converter,
  }) : this(
          HandledResponse.fromDioResult(dioResponse),
          castedData: dioResponse.data == null ? null : converter?.call(dioResponse.data!),
        );

  ComplexResponse.fromException(Exception exception) : this(HandledResponse.fromException(exception));

  ServerResponse get successResponse => this;

  HandledResponse get errorResponse => this;
}

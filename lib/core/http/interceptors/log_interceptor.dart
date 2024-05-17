import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class PrettyDioLogInterceptor extends Interceptor {
  static const _encoder = JsonEncoder.withIndent('  ');
  final Logger _logger;
  final int maxErrorLength;

  const PrettyDioLogInterceptor(this._logger,{
    this.maxErrorLength = 10000,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final message = 'URl: ${Uri.decodeFull(options.uri.toString())} \n'
        'Request method: ${options.method}\n'
        'Request headers: ${_prettyJson(options.headers)} \n'
        'Request body: ${_prettyJson(options.data)}';
    _logger.i(message);
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = 'URl: ${Uri.decodeFull(err.requestOptions.uri.toString())} \n'
        'Request method: ${err.requestOptions.method}\n'
        'Request headers: ${_prettyJson(err.requestOptions.headers)}\n'
        'Error: $err';
    _logger.e(message);
    handler.next(err);
  }

  @override
  void onResponse(
      Response<Object?> response,
      ResponseInterceptorHandler handler,
      ) {
    final message = 'URl: ${Uri.decodeFull(response.requestOptions.uri.toString())} \n'
        'code :${response.statusCode} \n'
        'Response headers: ${_prettyJson(response.headers.map)} \n'
        'Response body: ${response.requestOptions.responseType == ResponseType.json ? _prettyJson(response.data) : 'Not JSON'}';
    _logger.i(message);
    handler.next(response);
  }

  String _prettyJson(Object? data) {
    if (data == null) {
      return '{}';
    }
    if (data is! Map && data is! List) {
      return 'unsupported format';
    }
    try {
      final result = _encoder.convert(data);
      return result.substring(0, min(result.length, maxErrorLength));
    } on Exception {
      return 'Error parsing json body';
    }
  }
}
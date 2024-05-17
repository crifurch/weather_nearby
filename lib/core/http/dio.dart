import 'package:dio/dio.dart';
import 'package:whether_nearby/core/http/interceptors/log_interceptor.dart';
import 'package:whether_nearby/flavor/environment.dart';


class DioProvider {
  final Environment _environment;
  final PrettyDioLogInterceptor _logInterceptor;

  DioProvider({
    required Environment environment,
    required PrettyDioLogInterceptor logInterceptor,
  })  : _environment = environment,
        _logInterceptor = logInterceptor {
    configureDio();
  }

  final Dio _dio = Dio();

  BaseOptions get _options => BaseOptions(
    baseUrl: _environment.apiUrl,
    connectTimeout: const Duration(seconds: 10),
    listFormat: ListFormat.multiCompatible,
    contentType: Headers.jsonContentType,
  );


  Dio get api => _dio;

  void configureDio() {
    _dio.options = _options;
    _dio.interceptors.addAll([
      _logInterceptor,
    ]);
  }

}
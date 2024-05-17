import 'package:dio/dio.dart';
import 'package:weather_nearby/core/http/interceptors/apikey_interceptor.dart';
import 'package:weather_nearby/core/http/interceptors/lang_interceptor.dart';
import 'package:weather_nearby/core/http/interceptors/log_interceptor.dart';
import 'package:weather_nearby/flavor/environment.dart';

class DioProvider {
  final Environment _environment;
  final PrettyDioLogInterceptor _logInterceptor;
  final ApiKeyInterceptor _apiKeyInterceptor;
  final LangInterceptor _langInterceptor;

  DioProvider({
    required Environment environment,
    required PrettyDioLogInterceptor logInterceptor,
    required ApiKeyInterceptor apiKeyInterceptor,
    required LangInterceptor langInterceptor,
  })  : _environment = environment,
        _logInterceptor = logInterceptor,
        _apiKeyInterceptor = apiKeyInterceptor,
        _langInterceptor = langInterceptor {
    configureDio();
  }

  final Dio _dio = Dio();

  BaseOptions get _options => BaseOptions(
        baseUrl: _environment.apiUrl,
        connectTimeout: const Duration(seconds: 10),
        listFormat: ListFormat.multiCompatible,
      );

  Dio get weatherApi => _dio;

  void configureDio() {
    _dio.options = _options;
    _dio.interceptors.addAll([
      _apiKeyInterceptor,
      _langInterceptor,
      _logInterceptor,
    ]);
  }
}

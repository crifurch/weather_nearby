import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:weather_nearby/core/http/dio.dart';
import 'package:weather_nearby/core/http/interceptors/apikey_interceptor.dart';
import 'package:weather_nearby/core/http/interceptors/lang_interceptor.dart';
import 'package:weather_nearby/core/http/interceptors/log_interceptor.dart';
import 'package:weather_nearby/core/localization/country_strings.dart';
import 'package:weather_nearby/core/localization/string_provider.dart';
import 'package:weather_nearby/features/main_screen/data/weather_repository.dart';
import 'package:weather_nearby/features/user_settings/data/user_settings_repository.dart';
import 'package:weather_nearby/flavor/environment.dart';

final locator = GetIt.I;

Future<void> setupLocator(Environment environment) async {
  locator
    ..registerSingleton(environment)
    ..registerSingleton(Logger())
    ..registerSingleton(GetStorage())
    ..registerSingleton<StringProvider>(
      StringProvider(CountryStrings('en', {})),
    )

    ///register http layer
    ..registerSingleton(PrettyDioLogInterceptor(locator.get()))
    ..registerSingleton(ApiKeyInterceptor(apiKey: environment.apiKey))
    ..registerSingleton(LangInterceptor(stringProvider: locator.get()))
    ..registerSingleton(DioProvider(
      environment: environment,
      logInterceptor: locator.get(),
      apiKeyInterceptor: locator.get(),
      langInterceptor: locator.get(),
    ));

  await locator.get<GetStorage>().initStorage;
  await _initRepositories();
  await _initBlocs();
}

Future<void> _initRepositories() async {
  locator
    ..registerFactory(() => UserSettingsRepository(
          prefs: locator.get(),
        ))
    ..registerFactory(() => WeatherRepository(
          client: locator.get<DioProvider>().weatherApi,
        ));
}

Future<void> _initBlocs() async {}

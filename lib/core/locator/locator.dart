import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:whether_nearby/core/http/dio.dart';
import 'package:whether_nearby/core/http/interceptors/log_interceptor.dart';
import 'package:whether_nearby/core/localization/country_strings.dart';
import 'package:whether_nearby/core/localization/string_provider.dart';
import 'package:whether_nearby/features/user_settings/data/user_settings_repository.dart';
import 'package:whether_nearby/flavor/environment.dart';

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
    ..registerSingleton(DioProvider(
      environment: environment,
      logInterceptor: locator.get(),
    ));

  await locator.get<GetStorage>().initStorage;
  await _initRepositories();
  await _initBlocs();
}

Future<void> _initRepositories() async {
  locator.registerFactory(() => UserSettingsRepository(
        prefs: locator.get(),
      ));
}

Future<void> _initBlocs() async {}

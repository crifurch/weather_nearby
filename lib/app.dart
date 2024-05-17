import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:weather_nearby/core/localization/string_provider.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/core/locator/locator.dart';
import 'package:weather_nearby/features/main_screen/main_screen.dart';
import 'package:weather_nearby/features/user_settings/data/user_settings_repository.dart';
import 'package:weather_nearby/flavor/environment.dart';

Future<void> setupApp(Environment environment) async {
  setPathUrlStrategy();
  await setupLocator(environment);
  WidgetsFlutterBinding.ensureInitialized();
  final stringProvider = locator.get<StringProvider>()
    ..countryStrings = await locator.get<UserSettingsRepository>().locale.toCountryStrings();
  runApp(MyApp(
    stringProvider: stringProvider,
  ));
}

class MyApp extends StatelessWidget {
  final StringProvider stringProvider;

  const MyApp({
    super.key,
    required this.stringProvider,
  });

  @override
  Widget build(BuildContext context) => TranslationServiceProvider(
        stringProvider: stringProvider,
        initialTranslations: stringProvider.countryStrings,
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: MainScreen.routeName,
          routes: {
            MainScreen.routeName: (context) => const MainScreen(),
          },
        ),
      );
}

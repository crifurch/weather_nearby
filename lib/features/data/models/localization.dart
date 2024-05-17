import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:weather_nearby/core/localization/country_strings.dart';

enum LocalizationsEnum {
  en,
  ru;

  static LocalizationsEnum fromString(String locale) {
    switch (locale) {
      case 'en':
        return LocalizationsEnum.en;
      default:
        return LocalizationsEnum.ru;
    }
  }

  static LocalizationsEnum fromCountryStrings(CountryStrings strings) => LocalizationsEnum.values.firstWhere(
        (element) => element.name == strings.code,
        orElse: () => LocalizationsEnum.en,
      );

  Future<CountryStrings> toCountryStrings() async => CountryStrings(
        name,
        jsonDecode(
          await rootBundle.loadString('assets/locale/${name}.json'),
        ),
      );
}

// ignore_for_file: type_annotate_public_apis

import 'country_strings.dart';

class StringProvider {
  late CountryStrings countryStrings;

  StringProvider(CountryStrings value) : countryStrings = value;

  String translate(String key, [var args]) => countryStrings.translate(key, args);
}
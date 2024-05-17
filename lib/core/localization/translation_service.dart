// ignore_for_file: type_annotate_public_apis

import 'package:flutter/material.dart';
import 'package:weather_nearby/core/localization/country_strings.dart';
import 'package:weather_nearby/core/localization/string_provider.dart';

class TranslationService extends InheritedWidget {
  final CountryStrings _countryStrings;
  final void Function(CountryStrings) _onCountryStringsChanged;
  final StringProvider _stringProvider;

  const TranslationService({
    required CountryStrings countryStrings,
    required void Function(CountryStrings) onCountryStringsChanged,
    required StringProvider stringProvider,
    required super.child,
    super.key,
  })  : _countryStrings = countryStrings,
        _onCountryStringsChanged = onCountryStringsChanged,
        _stringProvider = stringProvider;

  static TranslationService of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TranslationService>()!;

  @override
  bool updateShouldNotify(TranslationService oldWidget) => _countryStrings != oldWidget._countryStrings;

  StringProvider get stringProvider => _stringProvider;

  CountryStrings get countryStrings => _countryStrings;

  set countryStrings(CountryStrings countryStrings) {
    _onCountryStringsChanged(countryStrings);
  }

  String translate(String key, [var args]) => _countryStrings.translate(key, args);
}

class TranslationServiceProvider extends StatefulWidget {
  final Widget child;
  final CountryStrings initialTranslations;
  final StringProvider stringProvider;

  const TranslationServiceProvider({
    required this.child,
    required this.initialTranslations,
    required this.stringProvider,
    super.key,
  });

  @override
  State<TranslationServiceProvider> createState() => _TranslationServiceProviderState();
}

class _TranslationServiceProviderState extends State<TranslationServiceProvider> {
  late CountryStrings _countryStrings;

  @override
  void initState() {
    super.initState();
    _countryStrings = widget.initialTranslations;
    widget.stringProvider.countryStrings = _countryStrings;
  }

  @override
  Widget build(BuildContext context) => TranslationService(
        countryStrings: _countryStrings,
        onCountryStringsChanged: _setCountryStrings,
        stringProvider: widget.stringProvider,
        child: widget.child,
      );

  void _setCountryStrings(CountryStrings countryStrings) {
    setState(() {
      widget.stringProvider.countryStrings = countryStrings;
      _countryStrings = countryStrings;
    });
  }
}

extension BuildContextStringProvider on BuildContext {
  CountryStrings countryStrings() => TranslationService.of(this).countryStrings;

  StringProvider get stringProvider => TranslationService.of(this).stringProvider;

  String translate(String key, [var args]) => countryStrings().translate(key, args);
}

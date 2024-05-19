import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/core/localization/translations_keys.dart';
import 'package:weather_nearby/features/main_screen/widgets/title_bar/country_search_field.dart';
import 'package:weather_nearby/features/main_screen/widgets/title_bar/language_switch.dart';
import 'package:weather_nearby/features/main_screen/widgets/title_bar/logo.dart';

class AppTitleBar extends StatelessWidget {
  final OnLangChangedCallback? onLangChanged;
  final FocusNode? langFieldFocusNode;
  final void Function(String value)? onLocationSearch;
  final VoidCallback? onUpdate;
  final String? initLocation;
  final bool isLoading;

  const AppTitleBar({
    super.key,
    this.onLangChanged,
    this.langFieldFocusNode,
    this.onLocationSearch,
    this.onUpdate,
    this.initLocation,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Logo(),
          const SizedBox(width: 15),
          Flexible(
            child: Center(
              child: LimitedBox(
                maxWidth: 600,
                child: CountrySearchField(
                  focusNode: langFieldFocusNode,
                  options: context.countryStrings.get<List>(TranslationsKeys.citiesOptions)?.cast() ?? [],
                  onSearch: onLocationSearch,
                  initValue: initLocation,
                  onUpdate: onUpdate,
                  isLoading: isLoading,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          FractionallySizedBox(
            heightFactor: 0.4,
            child: LanguageSwitch(
              onLangChanged: onLangChanged,
            ),
          ),
        ],
      );
}

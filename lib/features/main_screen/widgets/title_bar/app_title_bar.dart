import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_nearby/features/main_screen/widgets/title_bar/country_search_field.dart';
import 'package:weather_nearby/features/main_screen/widgets/title_bar/language_switch.dart';
import 'package:weather_nearby/features/main_screen/widgets/title_bar/logo.dart';

class AppTitleBar extends StatelessWidget {
  final OnLangChangedCallback? onLangChanged;

  const AppTitleBar({
    super.key,
    this.onLangChanged,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Logo(),
          const SizedBox(width: 10),
          const Flexible(
            child: Center(
              child: LimitedBox(
                maxWidth: 600,
                child: CountrySearchField(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          FractionallySizedBox(
            heightFactor: 0.4,
            child: LanguageSwitch(
              onLangChanged: onLangChanged,
            ),
          ),
        ],
      );
}

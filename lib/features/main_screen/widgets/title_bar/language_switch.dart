import 'package:flutter/material.dart';
import 'package:weather_nearby/core/app_colors.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/core/localization/translations_keys.dart';
import 'package:weather_nearby/core/widgets/layout/limited_aspect_ratio.dart';
import 'package:weather_nearby/core/widgets/simple/basic_text.dart';
import 'package:weather_nearby/features/data/models/localization.dart';
typedef OnLangChangedCallback = void Function(LocalizationsEnum lang);
class LanguageSwitch extends StatelessWidget {
  static const _locales = {
    LocalizationsEnum.en: TranslationsKeys.langEn,
    LocalizationsEnum.ru: TranslationsKeys.langRu,
  };
  final OnLangChangedCallback? onLangChanged;
  final bool enabled;

  const LanguageSwitch({
    super.key,
    this.onLangChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final lang = LocalizationsEnum.fromCountryStrings(context.countryStrings);
    return LimitedAspectRatio(
      aspectRatio: 1.5*_locales.length.toDouble(),
      maxHeight: 100,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: AppColors.secondary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _locales.length,
              (index) {
                final isCurrentVal = lang == _locales.keys.elementAt(index);
                return Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: isCurrentVal ? Colors.white : Colors.transparent,
                    ),
                    child: MouseRegion(
                      cursor: isCurrentVal && enabled ? MouseCursor.defer : SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: isCurrentVal && enabled ? null : () => onLangChanged?.call(_locales.keys.elementAt(index)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                          child: Center(
                            child: FittedBox(
                              child: BasicText(
                                context.translate(_locales.values.elementAt(index)),
                                textColor: isCurrentVal ? AppColors.textPrimary : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

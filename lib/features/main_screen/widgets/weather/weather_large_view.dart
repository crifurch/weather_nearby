import 'package:flutter/material.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/core/localization/translations_keys.dart';
import 'package:weather_nearby/core/utils/temperature_utils.dart';
import 'package:weather_nearby/core/widgets/simple/basic_text.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';

class WeatherLargeView extends StatelessWidget {
  final WeatherData weatherData;
  final bool isCurrent;

  const WeatherLargeView({
    super.key,
    required this.weatherData,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BasicText(
            isCurrent
                ? '${context.dateFormatter.userFriendly.format(weatherData.dateTime.toLocal())}, '
                    '${context.translate(TranslationsKeys.now)}'
                : context.dateFormatter.userFriendly.format(weatherData.dateTime.toLocal()),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          const SizedBox(height: 10),
          const Spacer(),
          BasicText(
            _tempToString(weatherData.weatherValues.temp),
            fontWeight: FontWeight.w700,
            textScaleFactor: 5,
          ),
          const Spacer(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 3,
                horizontal: 5,
              ),
              child: BasicText(
                context.translate(TranslationsKeys.feelLike, _tempToString(weatherData.weatherValues.tempFeelsLike)),
                fontSize: 12,
              ),
            ),
          ),
        ],
      );

  String _tempToString(num value) => '${value > 0 ? '+' : ''}'
      '${convertToCelsius(value.toDouble()).round()}';
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/core/localization/translations_keys.dart';
import 'package:weather_nearby/core/widgets/layout/limited_aspect_ratio.dart';
import 'package:weather_nearby/core/widgets/simple/basic_text.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/weather_data.dart';

class WeatherSmallView extends StatelessWidget {
  final WeatherData weatherData;
  final bool isCurrent;

  const WeatherSmallView({
    super.key,
    required this.weatherData,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LimitedAspectRatio(
                aspectRatio: 5,
                maxHeight: 25,
                child: FittedBox(
                  child: BasicText(
                    isCurrent
                        ? context.translate(TranslationsKeys.now)
                        : context.dateFormatter.hhmm.format(weatherData.dateTime.toLocal()),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: LimitedAspectRatio(
                  aspectRatio: 1,
                  maxHeight: 100,
                  maxWidth: 100,
                  child: CachedNetworkImage(
                    imageUrl: 'https://openweathermap.org/img/wn/${weatherData.weather.first.icon}@2x.png',
                  ),
                ),
              ),
              LimitedAspectRatio(
                aspectRatio: 5,
                maxHeight: 25,
                child: FittedBox(
                  child: BasicText(
                    weatherData.weather.first.description,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

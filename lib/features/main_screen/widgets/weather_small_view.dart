import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';

class WeatherSmallView extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherSmallView({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.dateFormatter.hhmm.format(weatherData.dateTime.toLocal()),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: LimitedBox(
                  maxHeight: 100,
                  maxWidth: 100,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: 'https://openweathermap.org/img/wn/${weatherData.weather.first.icon}@2x.png',
                    ),
                  ),
                ),
              ),
              Text(
                weatherData.weather.first.description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

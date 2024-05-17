import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';

class WeatherLargeView extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherLargeView({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        context.dateFormatter.userFriendly.format(weatherData.dateTime.toLocal()),
      ),
      CachedNetworkImage(
        imageUrl: 'https://openweathermap.org/img/wn/${weatherData.weather.first.icon}@2x.png',
      ),
      Text(
        weatherData.weather.first.description,
      ),
    ],
  );
}

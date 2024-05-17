import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_nearby/core/widgets/layout/limited_aspect_ratio.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';
import 'package:weather_nearby/features/main_screen/widgets/weather_large_view.dart';
import 'package:weather_nearby/features/main_screen/widgets/whether_forecast_carousel.dart';

class DayWeatherView extends StatefulWidget {
  final List<WeatherData> dayWeathersData;

  const DayWeatherView({
    super.key,
    required this.dayWeathersData,
  });

  @override
  State<DayWeatherView> createState() => _DayWeatherViewState();
}

class _DayWeatherViewState extends State<DayWeatherView> {
  WeatherData? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.dayWeathersData.isNotEmpty ? widget.dayWeathersData.first : null;
  }

  @override
  void didUpdateWidget(covariant DayWeatherView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _current = widget.dayWeathersData.isNotEmpty ? widget.dayWeathersData.first : null;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_current != null)
            LimitedBox(
              maxHeight: 400,
              child: WeatherLargeView(
                weatherData: _current!,
              ),
            ),
          LimitedAspectRatio(
            maxHeight: 150,
            aspectRatio: 5,
            child: WeatherForecastCarousel(
              weathersData: widget.dayWeathersData,
              onCurrentWeatherDataChanged: (current) => setState(() => _current = current),
            ),
          ),
        ],
      );
}

import 'package:flutter/material.dart';
import 'package:weather_nearby/core/widgets/decoration/card_decoration.dart';
import 'package:weather_nearby/core/widgets/layout/limited_aspect_ratio.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';
import 'package:weather_nearby/features/main_screen/widgets/weather/weather_large_view.dart';
import 'package:weather_nearby/features/main_screen/widgets/weather/whether_forecast_carousel.dart';

class ForecastWeatherView extends StatefulWidget {
  final List<WeatherData> forecastWeatherData;
  final WeatherData? currentWeatherData;

  const ForecastWeatherView({
    super.key,
    required this.forecastWeatherData,
    this.currentWeatherData,
  });

  @override
  State<ForecastWeatherView> createState() => _ForecastWeatherViewState();
}

class _ForecastWeatherViewState extends State<ForecastWeatherView> {
  WeatherData? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.forecastWeatherData.isNotEmpty ? widget.forecastWeatherData.first : null;
  }

  @override
  void didUpdateWidget(covariant ForecastWeatherView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _current = widget.forecastWeatherData.isNotEmpty ? widget.forecastWeatherData.first : null;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_current != null)
            CardDecoration(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: LimitedAspectRatio(
                  aspectRatio: 2,
                  minWidth: 200,
                  minHeight: 200,
                  maxWidth: 1300,
                  maxHeight: 600,
                  child: Center(
                    child: WeatherLargeView(
                      weatherData: _current!,
                      isCurrent: _current == widget.currentWeatherData,
                    ),
                  ),
                ),
              ),
            ),
          if (widget.forecastWeatherData.isNotEmpty)
            LimitedAspectRatio(
              maxHeight: 150,
              maxWidth: 1300,
              aspectRatio: 4.5,
              //fix flutter render glitch
              child: Transform.translate(
                offset: const Offset(0, -0.3),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: WeatherForecastCarousel(
                    weathersData: widget.forecastWeatherData,
                    currentWeatherData: widget.currentWeatherData,
                    onCurrentWeatherDataChanged: (current) => setState(() => _current = current),
                  ),
                ),
              ),
            ),
        ],
      );
}

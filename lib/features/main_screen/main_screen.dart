import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_nearby/core/locator/locator.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';
import 'package:weather_nearby/features/main_screen/presentation/weather_bloc.dart';
import 'package:weather_nearby/features/main_screen/widgets/day_weather_view.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _weatherBloc = locator.get<WeatherBloc>();

  @override
  void initState() {
    super.initState();
    _weatherBloc.add(WeatherEvent.loadData());
  }

  @override
  Widget build(BuildContext context) => Material(
        child: BlocBuilder<WeatherBloc, WeatherState>(
          bloc: _weatherBloc,
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final forecast = <WeatherData>[];
            state.forecastWeather.forEach((key, value) {
              forecast.addAll(value);
              if (key == 0 && state.currentWeather != null) {
                forecast
                  ..add(state.currentWeather!)
                  ..sort(
                    (a, b) => a.dateTime.millisecondsSinceEpoch.compareTo(b.dateTime.millisecondsSinceEpoch),
                  );
              }
            });
            return Column(
              children: [
                DayWeatherView(
                  dayWeathersData: forecast,
                ),
              ],
            );
          },
        ),
      );
}

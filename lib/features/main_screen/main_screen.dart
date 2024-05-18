import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_nearby/core/app_colors.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/core/locator/locator.dart';
import 'package:weather_nearby/core/widgets/layout/limited_aspect_ratio.dart';
import 'package:weather_nearby/features/data/models/localization.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/whether/weather_data.dart';
import 'package:weather_nearby/features/main_screen/presentation/weather_bloc.dart';
import 'package:weather_nearby/features/main_screen/widgets/title_bar/app_title_bar.dart';
import 'package:weather_nearby/features/main_screen/widgets/weather/forecast_weather_view.dart';
import 'package:weather_nearby/features/user_settings/data/user_settings_repository.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _weatherBloc = locator.get<WeatherBloc>();
  final _userSettingsRepository = locator.get<UserSettingsRepository>();

  @override
  void initState() {
    super.initState();
    _weatherBloc.add(const WeatherEvent.loadData());
  }

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.background,
        child: BlocBuilder<WeatherBloc, WeatherState>(
          bloc: _weatherBloc,
          builder: (context, state) {
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
            return SingleChildScrollView(
              child: FractionallySizedBox(
                widthFactor: 0.98,
                child: Column(
                  children: [
                    LimitedAspectRatio(
                      aspectRatio: 5,
                      maxHeight: 120,
                      maxWidth: 1700,
                      child: AppTitleBar(
                        onLangChanged: _onLangChanged,
                      ),
                    ),
                    if (state.isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      ForecastWeatherView(
                        forecastWeatherData: forecast,
                        currentWeatherData: state.currentWeather,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  Future<void> _onLangChanged(LocalizationsEnum lang) async {
    _userSettingsRepository.locale = lang;
    TranslationService.of(context).countryStrings = await lang.toCountryStrings();
    _weatherBloc.add(const WeatherEvent.loadData());
  }
}

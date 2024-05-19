import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_nearby/core/app_colors.dart';
import 'package:weather_nearby/core/localization/translation_service.dart';
import 'package:weather_nearby/core/locator/locator.dart';
import 'package:weather_nearby/core/widgets/layout/limited_aspect_ratio.dart';
import 'package:weather_nearby/features/data/models/localization.dart';
import 'package:weather_nearby/features/data/models/requesting_location.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/weather_data.dart';
import 'package:weather_nearby/features/main_screen/presentation/weather_bloc.dart';
import 'package:weather_nearby/features/main_screen/widgets/loading_card.dart';
import 'package:weather_nearby/features/main_screen/widgets/title_bar/app_title_bar.dart';
import 'package:weather_nearby/features/main_screen/widgets/weather/forecast_weather_view.dart';
import 'package:weather_nearby/features/main_screen/widgets/weather/weather_large_view.dart';
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
  final _langFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _weatherBloc.add(const WeatherEvent.init());
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
                        langFieldFocusNode: _langFieldFocusNode,
                        onLocationSearch: _onLocationChanged,
                        initLocation: _userSettingsRepository.location.location,
                        onUpdate: () => _weatherBloc.add(const WeatherEvent.updateAll()),
                        isLoading: state.isLoading,
                      ),
                    ),
                    if (forecast.isEmpty)
                      LoadingCard(
                        isLoading: state.isLoading,
                        onReloadClick: () => _weatherBloc.add(const WeatherEvent.updateAll()),
                        onChangeLocationClick: _langFieldFocusNode.requestFocus,
                        location: state.requestingLocation,
                      )
                    else
                      ForecastWeatherView(
                        forecastWeatherData: forecast,
                        currentWeatherData: state.currentWeather,
                        additionalDetails: WeatherAdditionalDetails(
                          lat: state.locationParams?.coords?.lat,
                          lon: state.locationParams?.coords?.lon,
                          cityName: state.locationParams?.cityName ?? state.requestingLocation?.location,
                          lastUpdateUTC: state.lastUpdateTime,
                          latsLocationUpdateUTC: state.requestingLocation?.updatedTimeUTC,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  void _onLocationChanged(String value) {
    if (_weatherBloc.state.requestingLocation?.location == value) {
      return;
    }
    _weatherBloc.add(WeatherEvent.loadData(location: RequestingLocation(location: value)));
  }

  Future<void> _onLangChanged(LocalizationsEnum lang) async {
    _userSettingsRepository.locale = lang;
    TranslationService.of(context).countryStrings = await lang.toCountryStrings();
    _weatherBloc.add(const WeatherEvent.updateAll());
  }

  @override
  void dispose() {
    _langFieldFocusNode.dispose();
    super.dispose();
  }
}

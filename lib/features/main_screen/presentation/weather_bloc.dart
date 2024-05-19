import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_nearby/core/cache/cache_store.dart';
import 'package:weather_nearby/core/mapper/data_mapper.dart';
import 'package:weather_nearby/features/data/models/requesting_location.dart';
import 'package:weather_nearby/features/main_screen/data/models/request/weather_request_param.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/api_whether_response.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/sys.dart';
import 'package:weather_nearby/features/main_screen/data/models/response/weather/weather_data.dart';
import 'package:weather_nearby/features/main_screen/data/weather_repository.dart';
import 'package:weather_nearby/features/main_screen/presentation/models/location_params.dart';
import 'package:weather_nearby/features/main_screen/presentation/models/weather_cache.dart';
import 'package:weather_nearby/features/user_settings/data/user_settings_repository.dart';

part 'weather_bloc.freezed.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  static const _weatherCacheKey = 'weather';

  final WeatherRepository _weatherRepository;
  final DataMapper<WeatherRequestParam, RequestingLocation> _weatherRequestParamMapper;
  final UserSettingsRepository _userSettingsRepository;
  final CacheStore _cacheStore;

  Timer? _timer;

  WeatherBloc({
    required WeatherRepository weatherRepository,
    required DataMapper<WeatherRequestParam, RequestingLocation> weatherRequestParamMapper,
    required UserSettingsRepository userSettingsRepository,
    required CacheStore cacheStore,
  })  : _weatherRepository = weatherRepository,
        _weatherRequestParamMapper = weatherRequestParamMapper,
        _userSettingsRepository = userSettingsRepository,
        _cacheStore = cacheStore,
        super(const WeatherState()) {
    on<WeatherEvent>(
      (event, emit) => event.when<Future<void>>(
        init: () => _init(emit),
        loadData: (location) => _loadData(location, emit),
        updateAll: () => _updateAll(emit),
        updateCurrentWeather: () => _updateCurrentWeather(emit),
      ),
    );
  }

  Future<void> _init(Emitter<WeatherState> emit) async {
    emit(state.copyWith(requestingLocation: _userSettingsRepository.location));
    final cache = _cacheStore.get(_weatherCacheKey);
    if (cache != null) {
      final restoredData = WeatherCache.fromJson(cache);
      emit(state.copyWith(
        forecastWeather: restoredData.forecastWeather,
        currentWeather: restoredData.currentWeather,
        lastUpdateTime: restoredData.cacheTimeUTC,
        locationParams: restoredData.locationParams,
      ));
    }
    add(const WeatherEvent.loadData());
  }

  Future<void> _loadData(RequestingLocation? location, Emitter<WeatherState> emit) async {
    final requestingLocation = location ?? state.requestingLocation;
    if (requestingLocation != null) {
      _userSettingsRepository.location = requestingLocation;
    }
    emit(state.copyWith(
      requestingLocation: requestingLocation,
    ));
    await _updateAll(emit);
  }

  Future<void> _updateAll(Emitter<WeatherState> emit) async {
    if (state.requestingLocation == null) {
      return;
    }
    _debounceAutoUpdate();
    emit(state.copyWith(
      isLoading: true,
    ));
    final forecastResponse = await _weatherRepository.getForecast(
      _weatherRequestParamMapper.mapToSecond(state.requestingLocation!),
    );
    if (forecastResponse.isSuccess) {
      final forecast = forecastResponse.castedData!;
      final groupListsBy =
          forecast.weatherData.groupListsBy<int>((element) => element.dateTime.difference(DateTime.timestamp()).inDays);
      emit(state.copyWith(
        forecastWeather: groupListsBy,
        locationParams: LocationParams(
          cityName: forecast.city?.name ?? state.locationParams?.cityName,
          coords: forecast.city?.coord ?? state.locationParams?.coords,
          sys: Sys(
            sunrise: forecast.city?.sunrise ?? state.locationParams?.sys?.sunrise,
            sunset: forecast.city?.sunset ?? state.locationParams?.sys?.sunset,
          ),
        ),
      ));
      await _updateCurrentWeather(emit);
    } else {
      emit(state.copyWith(
        forecastWeather: forecastResponse.code == 404 ? {} : state.forecastWeather,
        locationParams: forecastResponse.code == 404 ? null : state.locationParams,
      ));
    }
    emit(state.copyWith(
      isLoading: false,
    ));
    _saveToCache();
  }

  Future<void> _updateCurrentWeather(Emitter<WeatherState> emit) async {
    if (state.requestingLocation == null) {
      return;
    }
    final requestingLocation = state.requestingLocation!;
    final currentWeatherResponse = await _weatherRepository.getCurrentWeather(
      _weatherRequestParamMapper.mapToSecond(requestingLocation),
    );
    final whetherResponse = currentWeatherResponse.castedData;
    emit(state.copyWith(
      currentWeather: currentWeatherResponse.code == 404 ? null : whetherResponse?.weatherData ?? state.currentWeather,
      locationParams: LocationParams(
        cityName: whetherResponse?.cityName ?? state.locationParams?.cityName,
        coords: whetherResponse?.coord ?? state.locationParams?.coords,
        sys: whetherResponse?.sys ?? state.locationParams?.sys,
      ),
      lastUpdateTime: currentWeatherResponse.isSuccess ? DateTime.timestamp() : state.lastUpdateTime,
    ));
    _saveToCache();
  }

  void _saveToCache() {
    _cacheStore.put(
      _weatherCacheKey,
      WeatherCache(
        cacheTimeUTC: DateTime.timestamp(),
        forecastWeather: state.forecastWeather,
        currentWeather: state.currentWeather,
        locationParams: state.locationParams,
      ).toJson(),
    );
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _debounceAutoUpdate() {
    _timer?.cancel();
    _timer = Timer(const Duration(minutes: 15), () => add(const WeatherEvent.updateAll()));
  }
}

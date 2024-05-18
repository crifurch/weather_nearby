import 'dart:convert';
import 'dart:ui';

import 'package:get_storage/get_storage.dart';
import 'package:weather_nearby/features/data/models/localization.dart';
import 'package:weather_nearby/features/data/models/requesting_location.dart';

class UserSettingsRepository {
  static const _localeKey = 'locale';
  static const _locationKey = 'location';
  final GetStorage _prefs;

  UserSettingsRepository({
    required GetStorage prefs,
  }) : _prefs = prefs;

  set locale(LocalizationsEnum locale) => _prefs.write(
        _localeKey,
        locale.name,
      );

  LocalizationsEnum get locale {
    final read = _prefs.read<String>(_localeKey);
    return LocalizationsEnum.fromString(
      read ?? PlatformDispatcher.instance.locale.languageCode,
    );
  }

  set location(RequestingLocation? location) => _prefs.write(
        _locationKey,
        location == null ? null : jsonEncode(location.toJson()),
      );

  RequestingLocation? get location {
    final read = _prefs.read<String>(_locationKey);
    if (read == null) {
      return null;
    }
    return RequestingLocation.fromJson(jsonDecode(read));
  }
}

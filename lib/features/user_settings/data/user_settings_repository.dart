import 'dart:ui';

import 'package:get_storage/get_storage.dart';
import 'package:whether_nearby/features/user_settings/data/models/localization.dart';

class UserSettingsRepository {
  final GetStorage _prefs;

  UserSettingsRepository({
    required GetStorage prefs,
  }) : _prefs = prefs;

  Future<void> setLocale(LocalizationsEnum locale) => _prefs.write('locale', locale.name);

  LocalizationsEnum get locale {
    final read = _prefs.read<String>('locale');
    return LocalizationsEnum.fromString(
      read ?? PlatformDispatcher.instance.locale.languageCode,
    );
  }
}

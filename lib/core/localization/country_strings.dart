import 'package:sprintf/sprintf.dart';

class CountryStrings {
  final String code;
  final Map<String, dynamic> _localesMap;

  CountryStrings(this.code, this._localesMap);

  T? get<T>(String key) {
    Map<String, dynamic>? localesMap = _localesMap;
    final split = key.split('.');
    if (split.length > 1) {
      for (var i = 0; i < split.length - 1; i++) {
        final element = split[i];
        localesMap = localesMap?[element];
      }
    }
    final lastKey = split.last;
    var result = localesMap?[lastKey];
    if (result is List) {
      result = result.toList();
    }
    return result is T ? result : null;
  }

  // ignore: type_annotate_public_apis
  String translate(String key, [var args]) {
    var result = get<String>(key);
    if (result == null) {
      return '$key(null)';
    }
    if (args != null) {
      result = args is List ? sprintf(result, args) : sprintf(result, [args]);
    }
    return result;
  }
}

import 'package:sprintf/sprintf.dart';

class CountryStrings {
  final String code;
  final Map<String, dynamic> _localesMap;

  CountryStrings(this.code, this._localesMap);

  // ignore: type_annotate_public_apis
  String translate(String key, [var args]) {
    Map<String, dynamic>? localesMap = _localesMap;
    var result = '$key(null)';

    final split = key.split('.');
    if (split.length > 1) {
      for (var i = 0; i < split.length - 1; i++) {
        final element = split[i];
        localesMap = localesMap?[element];
      }
    }
    final lastKey = split.last;
    result = localesMap?[lastKey] ?? result;
    if (args != null) {
      result = args is List ? sprintf(result, args) : sprintf(result, [args]);
    }
    return result;
  }
}
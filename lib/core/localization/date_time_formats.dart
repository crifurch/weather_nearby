import 'package:intl/intl.dart';

class CustomDateFormat {
  final DateFormat hhmm;
  final DateFormat userFriendly;
  final DateFormat userFriendlyShort;

  CustomDateFormat(String languageCode)
      : hhmm = DateFormat('HH:mm', languageCode),
        userFriendly = DateFormat('EEEE, d MMM, HH:mm', languageCode),
        userFriendlyShort = DateFormat('EEEE, d MMM', languageCode);
}

import 'package:intl/intl.dart';

class CustomDateFormat {
  final DateFormat hhmm;
  final DateFormat userFriendly;

  CustomDateFormat(String languageCode)
      : hhmm = DateFormat('HH:mm', languageCode),
        userFriendly = DateFormat('EEEE, d MMM, HH:mm', languageCode);
}

import 'package:intl/intl.dart';

class Util{
  static String convertDateTimeDisplay(String date, [String format = "dd-MMMM-yyyy"]) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat(format);
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  // this is used to set the default date if the date is null
  static DateTime defaultDateIfNull = DateTime(1999, 9, 9, 9, 9, 9, 9, 9);

  // this is used to set the default string if the string is null
  static String defaultStringIfNull = "";
}
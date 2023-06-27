import 'package:intl/intl.dart';

class Util{
  static String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MMMM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  // this is used to set the default date if the date is null
  static DateTime defaultDateIfNull = DateTime(1999, 9, 9, 9, 9, 9, 9, 9);
}
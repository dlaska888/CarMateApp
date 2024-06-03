import 'package:iso8601_duration/iso8601_duration.dart';

class DateTimeHelper {
  static String convertToISO8601(ISODuration duration) {
    String result = 'P';
    if (duration.year != 0) {
      result += '${duration.year}Y';
    }
    if (duration.month != 0) {
      result += '${duration.month}M';
    }
    if (duration.day != 0) {
      result += '${duration.day}D';
    }
    result += 'T0H0M0S';
    return result;
  }
}

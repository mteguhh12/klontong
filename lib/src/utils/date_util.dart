import 'package:intl/intl.dart';
import 'package:klontong/src/utils/const.dart';

import 'logger.dart';

class DateUtil {
  static DateTime? parseStringToDate(String? dateStr, String format,
      {String? locale}) {
    DateTime? date;
    if (dateStr != null)
      try {
        date = DateFormat(format, locale ?? Const.LOCALE_EN).parse(dateStr);
      } on FormatException catch (e) {
        logger.e(e.toString());
      }
    return date;
  }

  static DateTime? parseStringAllFormats(String? dateStr) {
    return parseString(dateStr, formats: [
      Const.DATE_FORMAT,
      Const.DATE_FORMAT_REQUEST,
      Const.DATE_FORMAT_EXPIRATION,
      "mm/DD/yyyy",
    ]);
  }

  static DateTime? parseString(String? dateStr,
      {required List<String> formats}) {
    for (int i = 0; i < Const.LIST_LOCALE.length; ++i) {
      for (int j = 0; j < formats.length; ++j) {
        DateTime? tryParse = parseStringToDate(dateStr, formats[j],
            locale: Const.LIST_LOCALE[i]);
        if (tryParse != null) {
          return tryParse;
        }
      }
    }
    return null;
  }

  static String parseDateToString(DateTime? dateTime, String format) {
    String date = "";
    if (dateTime != null)
      try {
        date = DateFormat(format, Const.LOCALE_EN).format(dateTime);
      } on FormatException catch (e) {
        logger.e(e.toString());
      }
    return date;
  }

  static String? parseStringDateToString(
      String? dateSv, String fromFormat, String toFormat) {
    String? date = dateSv;
    if (dateSv != null)
      try {
        date = DateFormat(toFormat, Const.LOCALE_EN)
            .format(DateFormat(fromFormat, Const.LOCALE_EN).parse(dateSv));
      } on FormatException catch (e) {
        logger.d(e.toString());
      }
    return date;
  }
}

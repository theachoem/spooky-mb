// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'package:intl/intl.dart';

class DateFormatService {
  static String MMM(DateTime date) {
    return DateFormat.MMM().format(date);
  }

  static yMEd_jms(DateTime date) {
    return DateFormat.yMEd().addPattern("- ${DateFormat.jms().pattern!}").format(date);
  }

  static jms(DateTime date) {
    return DateFormat.jms().format(date);
  }
}

// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'package:intl/intl.dart';

class DateFormatService {
  static String E(DateTime date) {
    return DateFormat.E().format(date);
  }

  static String MMM(DateTime date) {
    return DateFormat.MMM().format(date);
  }

  static String yMEd_jms(DateTime date) {
    return DateFormat.yMEd().addPattern("- ${DateFormat.jms().pattern!}").format(date);
  }

  static String? yMEd_jmsNullable(DateTime? date) {
    if (date == null) return null;
    return DateFormat.yMEd().addPattern("- ${DateFormat.jms().pattern!}").format(date);
  }

  static yMEd(DateTime date) {
    return DateFormat.yMEd().format(date);
  }

  static jms(DateTime date) {
    return DateFormat.jms().format(date);
  }

  static yMd(DateTime date) {
    return DateFormat.yMd().format(date);
  }
}

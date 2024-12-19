// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'package:intl/intl.dart';

class DateFormatService {
  static String MMM(DateTime date) {
    return DateFormat.MMM().format(date);
  }
}

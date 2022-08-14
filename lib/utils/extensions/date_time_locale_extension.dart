import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

extension DateTimePickerLocaleExtension on DateTimePickerLocale {
  Locale get locale {
    switch (this) {
      case DateTimePickerLocale.enUs:
        return const Locale("en", "US");
      case DateTimePickerLocale.km:
        return const Locale("km");
      case DateTimePickerLocale.zhCn:
        return const Locale("zh", "CN");
      case DateTimePickerLocale.ptBr:
        return const Locale("pt", "BR");
      case DateTimePickerLocale.id:
        return const Locale("id");
      case DateTimePickerLocale.es:
        return const Locale("es");
      case DateTimePickerLocale.tr:
        return const Locale("tr");
      case DateTimePickerLocale.fr:
        return const Locale("fr");
      case DateTimePickerLocale.ro:
        return const Locale("ro");
      case DateTimePickerLocale.bn:
        return const Locale("bn");
      case DateTimePickerLocale.bs:
        return const Locale("bs");
      case DateTimePickerLocale.ar:
        return const Locale("ar");
      case DateTimePickerLocale.arEg:
        return const Locale("ar", "EG");
      case DateTimePickerLocale.jp:
        return const Locale("jp");
      case DateTimePickerLocale.ru:
        return const Locale("ru");
      case DateTimePickerLocale.de:
        return const Locale("de");
      case DateTimePickerLocale.cs:
        return const Locale("cs");
      case DateTimePickerLocale.ko:
        return const Locale("ko");
      case DateTimePickerLocale.it:
        return const Locale("it");
      case DateTimePickerLocale.hu:
        return const Locale("hu");
      case DateTimePickerLocale.hr:
        return const Locale("hr");
      case DateTimePickerLocale.uk:
        return const Locale("uk");
      case DateTimePickerLocale.vi:
        return const Locale("vi");
      case DateTimePickerLocale.srCyrl:
        return const Locale("sr", "CYRL");
      case DateTimePickerLocale.srLatn:
        return const Locale("sr", "LATN");
      case DateTimePickerLocale.nl:
        return const Locale("nl");
    }
  }
}

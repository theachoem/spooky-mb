import 'package:spooky/core/base_storages/enum_preference_storage.dart';

enum LocalAuthType {
  pin,
  password,
  biometric,
}

class LocalAuthStorage extends EnumPreferenceStorage {
  @override
  List get values => LocalAuthType.values;
}

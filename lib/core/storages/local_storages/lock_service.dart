import 'package:spooky/core/storages/base_storages/enum_storage.dart';

enum LocalAuthType {
  pin,
  password,
  biometric,
}

class LocalAuthStorage extends EnumPreferenceStorage {
  @override
  List get values => LocalAuthType.values;
}

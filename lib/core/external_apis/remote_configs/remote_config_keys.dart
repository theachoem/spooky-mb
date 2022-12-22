import 'package:spooky/core/external_apis/remote_configs/remote_config_service.dart';

part 'remote_config_key.dart';
part './keys/remote_config_boolean_key.dart';
part './keys/remote_config_string_key.dart';

class RemoteConfigKeys {
  static const List<RemoteConfigKey> keys = [
    ...RemoteConfigBooleanKeys.keys,
    ...RemoteConfigStringKeys.keys,
  ];
}

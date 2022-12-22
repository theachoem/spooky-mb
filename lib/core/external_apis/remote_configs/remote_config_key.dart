part of 'remote_config_keys.dart';

enum RemoteConfigValueType { boolean, string, int, double }

class RemoteConfigKey<T> {
  final String key;
  final RemoteConfigValueType type;
  final T defaultValue;

  const RemoteConfigKey._(
    this.key,
    this.type,
    this.defaultValue,
  );

  T get() {
    dynamic value;
    switch (type) {
      case RemoteConfigValueType.boolean:
        value = RemoteConfigService.instance.remoteConfig.getBool(key) as T;
        break;
      case RemoteConfigValueType.string:
        value = RemoteConfigService.instance.remoteConfig.getString(key) as T;
        break;
      case RemoteConfigValueType.double:
        value = RemoteConfigService.instance.remoteConfig.getDouble(key) as T;
        break;
      case RemoteConfigValueType.int:
        value = RemoteConfigService.instance.remoteConfig.getInt(key) as T;
        break;
    }

    if (value is T) return value;
    return defaultValue;
  }
}

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/external_apis/remote_configs/remote_config_keys.dart';

class RemoteConfigService {
  RemoteConfigService._();
  static final instance = RemoteConfigService._();
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 12),
    ));

    await remoteConfig.setDefaults({for (final e in RemoteConfigKeys.keys) e.key: e.defaultValue});
    bool fetched = await remoteConfig.fetchAndActivate();

    if (kDebugMode) print("RemoteConfigService initialized: $fetched");
  }
}

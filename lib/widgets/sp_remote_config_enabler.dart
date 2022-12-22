import 'package:flutter/material.dart';
import 'package:spooky/core/external_apis/remote_configs/remote_config_keys.dart';

class SpRemoteConfigEnabler extends StatelessWidget {
  const SpRemoteConfigEnabler({
    super.key,
    required this.remoteKey,
    required this.child,
  });

  final RemoteConfigKey<bool> remoteKey;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: remoteKey.get(),
      child: child,
    );
  }
}

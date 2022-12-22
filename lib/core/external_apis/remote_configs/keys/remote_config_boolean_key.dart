part of '../remote_config_keys.dart';

class RemoteConfigBooleanKeys {
  static const List<RemoteConfigKey> keys = [
    enableFacebookCommunityTile,
  ];

  static const boolean = RemoteConfigValueType.boolean;
  static const enableFacebookCommunityTile = RemoteConfigKey<bool>._(
    "enable_facebook_community_tile",
    boolean,
    false,
  );
}

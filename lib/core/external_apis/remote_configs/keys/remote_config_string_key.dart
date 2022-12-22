part of '../remote_config_keys.dart';

class RemoteConfigStringKeys {
  static const string = RemoteConfigValueType.string;
  static const List<RemoteConfigKey> keys = [
    linkToPrivacyPolicy,
    linkToGithub,
    linkToTelegramChannel,
    linkToFacebookGroupWeb1,
    linkToFacebookGroupWeb2,
    linkToFacebookGroupDeeplinkAndroid,
    linkToFacebookGroupDeeplinkIos,
    linkToCustomerSupport
  ];

  static const linkToPrivacyPolicy = RemoteConfigKey<String>._(
    "link_to_privacy_policy_url",
    string,
    "https://github.com/juniorise/spooky/wiki/Privacy-Policy",
  );

  static const linkToGithub = RemoteConfigKey<String>._(
    "link_to_open_source_code",
    string,
    'https://github.com/juniorise/spooky-mb/issues',
  );

  static const linkToTelegramChannel = RemoteConfigKey<String>._(
    "link_to_telegram_channel",
    string,
    'https://t.me/spookyjuniorise',
  );

  static const linkToFacebookGroupWeb1 = RemoteConfigKey<String>._(
    "link_to_facebook_group_web1",
    string,
    'https://www.facebook.com/groups/593901148915391',
  );

  static const linkToFacebookGroupWeb2 = RemoteConfigKey<String>._(
    "link_to_facebook_group_web2",
    string,
    'https://m.facebook.com/groups/593901148915391',
  );

  static const linkToFacebookGroupDeeplinkAndroid = RemoteConfigKey<String>._(
    "link_to_facebook_group_deeplink_android",
    string,
    'fb://group?id=593901148915391',
  );

  static const linkToFacebookGroupDeeplinkIos = RemoteConfigKey<String>._(
    "link_to_facebook_group_deeplink_ios",
    string,
    'fb://group/593901148915391',
  );

  static const linkToCustomerSupport = RemoteConfigKey<String>._(
    "link_to_customer_support",
    string,
    'https://t.me/spookymb',
  );
}

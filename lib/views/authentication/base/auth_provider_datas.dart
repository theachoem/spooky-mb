import 'dart:io';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/external_apis/social_auths/apple_auth_api.dart';
import 'package:spooky/core/external_apis/social_auths/base_social_auth_api.dart';
import 'package:spooky/core/external_apis/social_auths/facebook_auth_api.dart';
import 'package:spooky/core/external_apis/social_auths/google_auth_api.dart';

enum AuthProviderType {
  google,
  apple,
  facebook,
}

class AuthProviderDatas {
  final AuthProviderType type;
  final BaseSocialAuthApi authApi;

  String get title {
    switch (type) {
      case AuthProviderType.google:
        return "Google";
      case AuthProviderType.apple:
        return "Apple";
      case AuthProviderType.facebook:
        return "Facebook";
    }
  }

  IconData get iconData {
    switch (type) {
      case AuthProviderType.google:
        return CommunityMaterialIcons.google;
      case AuthProviderType.apple:
        return CommunityMaterialIcons.apple;
      case AuthProviderType.facebook:
        return CommunityMaterialIcons.facebook;
    }
  }

  String get providerId {
    switch (type) {
      case AuthProviderType.google:
        return "google.com";
      case AuthProviderType.apple:
        return "apple.com";
      case AuthProviderType.facebook:
        return "facebook.com";
    }
  }

  AuthProviderDatas({
    required this.type,
    required this.authApi,
  });

  static final List<AuthProviderDatas> items = [
    if (Platform.isMacOS || Platform.isIOS)
      AuthProviderDatas(
        authApi: AppleAuthApi(),
        type: AuthProviderType.apple,
      ),
    AuthProviderDatas(
      authApi: GoogleAuthApi(),
      type: AuthProviderType.google,
    ),
    AuthProviderDatas(
      authApi: FacebookAuthApi(),
      type: AuthProviderType.facebook,
    ),
  ];
}

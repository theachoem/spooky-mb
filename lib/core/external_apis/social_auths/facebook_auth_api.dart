import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:spooky/core/external_apis/social_auths/base_social_auth_api.dart';

class FacebookAuthApi extends BaseSocialAuthApi {
  @override
  Future<AuthCredential?> getCredential([Map? args]) async {
    LoginResult result = await FacebookAuth.instance.login(loginBehavior: LoginBehavior.nativeWithFallback);
    OAuthCredential? credential;

    if (result.status == LoginStatus.success) {
      final AccessToken? accessToken = result.accessToken;
      if (accessToken?.token == null) return null;
      credential = FacebookAuthProvider.credential(accessToken!.token);
    }

    return credential;
  }
}

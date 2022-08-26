import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:spooky/core/external_apis/social_auths/base_social_auth_api.dart';

class AppleAuthApi extends BaseSocialAuthApi {
  final OAuthProvider _oAuthProvider = OAuthProvider("apple.com");

  @override
  Future<AuthCredential?> getCredential([Map? args]) async {
    AuthorizationCredentialAppleID? result = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    OAuthCredential? credential;
    if (result.identityToken != null) {
      credential = _oAuthProvider.credential(
        idToken: String.fromCharCodes(result.identityToken?.codeUnits ?? []),
        accessToken: String.fromCharCodes(result.authorizationCode.codeUnits),
      );
    }

    return credential;
  }
}

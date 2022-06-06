import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spooky/core/api/social_auths/base_social_auth_api.dart';

class GoogleAuthApi extends BaseSocialAuthApi {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Future<AuthCredential?> getCredential([Map? args]) async {
    if (await googleSignIn.isSignedIn()) await googleSignIn.signOut();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    OAuthCredential? credential;

    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    }

    return credential;
  }
}

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';

class CloudServiceProvider extends ChangeNotifier {
  final GoogleAuthService googleAuth = GoogleAuthService.instance;
  GoogleSignInAccount? googleUser;

  CloudServiceProvider() {
    load();
  }

  Future<void> load() async {
    await loadAuthentication();
    notifyListeners();
  }

  Future<void> loadAuthentication() async {
    await googleAuth.googleSignIn.isSignedIn().then((signedIn) async {
      if (signedIn) {
        await googleAuth.signInSilently();
        googleUser = googleAuth.googleSignIn.currentUser;
      } else {
        googleUser = null;
      }
    });
  }

  Future<void> signInWithGoogle() async {
    await googleAuth.signIn();
    load();
  }

  Future<void> signOutOfGoogle() async {
    await googleAuth.signOut();
    await load();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class BaseSocialAuthApi {
  String? errorMessage;

  Future<AuthCredential?> getCredential([Map? args]);
  Future<User?> connect([Map? args]) async {
    errorMessage = null;

    AuthCredential? credential = await getCredential();
    if (credential == null) return null;

    try {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
      } else {
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
      // String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      return FirebaseAuth.instance.currentUser;
    } on FirebaseException catch (e) {
      if (kDebugMode) print("ERROR: getCredential $e");
      errorMessage = e.message;
      return null;
    }
  }
}

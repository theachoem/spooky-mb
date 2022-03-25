import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class BaseSocialAuthApi {
  String? errorMessage;

  Future<AuthCredential?> getCredential();
  Future<String?> getToken() async {
    errorMessage = null;

    AuthCredential? credential = await getCredential();
    if (credential == null) return null;

    try {
      if (FirebaseAuth.instance.currentUser != null) await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseException catch (e) {
      if (kDebugMode) print("ERROR: $e");
      errorMessage = e.message;
      return null;
    }

    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    return idToken;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:spooky/core/external_apis/cloud_firestore/models/user_cf_model.dart';
import 'package:spooky/core/external_apis/cloud_firestore/users_firestore_database.dart';

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
      await setInitialUserDatas();
      return FirebaseAuth.instance.currentUser;
    } on FirebaseException catch (e) {
      if (kDebugMode) print("ERROR: getCredential $e");
      errorMessage = e.message;
      return null;
    }
  }

  Future<void> setInitialUserDatas() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await UsersFirestoreDatabase().set(uid, UserCfModel(uid: uid));
    }
  }
}

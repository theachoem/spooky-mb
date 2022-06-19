import 'package:flutter/material.dart';

abstract class BaseCloudProvider extends ChangeNotifier {
  bool get isSignedIn;

  String get title;
  String? get subtitle;

  Future<void> signIn();
  Future<void> signOut();
}

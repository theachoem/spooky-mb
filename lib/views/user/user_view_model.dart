import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/views/authentication/base/auth_provider_datas.dart';

class UserViewModel extends BaseViewModel {
  final ValueNotifier<double> scrollOffsetNotifier = ValueNotifier<double>(0);
  final Map<String, AuthProviderDatas> availableProviders = {};
  final Map<String, UserInfo> connectedProviders = {};

  UserViewModel() {
    loadProvider();
    load();
  }

  @override
  void dispose() {
    scrollOffsetNotifier.dispose();
    super.dispose();
  }

  void loadProvider() {
    for (AuthProviderDatas e in AuthProviderDatas.items) {
      availableProviders[e.providerId] = e;
    }
  }

  UserInfo? getUserInfo(String providerId) {
    return connectedProviders[providerId];
  }

  Future<void> connect(AuthProviderDatas providerInfo, BuildContext context) async {
    final result = await providerInfo.authApi.connect();
    if (result != null) {
      MessengerService.instance.showSnackBar("Connect successfully", success: true);
      onConnect(result);
    } else {
      MessengerService.instance.showSnackBar(providerInfo.authApi.errorMessage ?? "Connect fail", success: false);
    }
  }

  bool hasPassword(User user) {
    return user.providerData.map((e) => e.providerId).contains('password');
  }

  void logout() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
      load();
      notifyListeners();
    }
  }

  Future<bool> unlink(String providerId, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    if (hasPassword(user) || user.providerData.length > 1) {
      await user.unlink(providerId);
      load();
      notifyListeners();
    }

    return connectedProviders.isEmpty || connectedProviders[providerId] == null;
  }

  void load() {
    connectedProviders.clear();
    final providers = FirebaseAuth.instance.currentUser?.providerData;
    for (UserInfo element in providers ?? []) {
      connectedProviders[element.providerId] = element;
    }
  }

  void onConnect(User user) {
    load();
    notifyListeners();
  }
}

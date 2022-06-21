import 'dart:io';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/api/social_auths/apple_auth_api.dart';
import 'package:spooky/core/api/social_auths/base_social_auth_api.dart';
import 'package:spooky/core/api/social_auths/facebook_auth_api.dart';
import 'package:spooky/core/api/social_auths/google_auth_api.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/services/messenger_service.dart';

class UserViewModel extends BaseViewModel {
  final ValueNotifier<double> scrollOffsetNotifier = ValueNotifier<double>(0);

  final AppleAuthApi _appleAuthApi = AppleAuthApi();
  final GoogleAuthApi _googleAuthApi = GoogleAuthApi();
  final FacebookAuthApi _facebookAuthApi = FacebookAuthApi();
  final Map<String, AvailableAuthProvider> availableProviders = {};
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
    final list = [
      AvailableAuthProvider(
        providerId: "facebook.com",
        title: 'Facebook',
        iconData: Icons.facebook,
        authApi: _facebookAuthApi,
      ),
      AvailableAuthProvider(
        providerId: "google.com",
        title: 'Google',
        iconData: CommunityMaterialIcons.google,
        authApi: _googleAuthApi,
      ),
      if (Platform.isIOS || Platform.isMacOS)
        AvailableAuthProvider(
          providerId: "apple.com",
          title: 'Apple',
          iconData: Icons.apple,
          authApi: _appleAuthApi,
        ),
    ];
    for (AvailableAuthProvider e in list) {
      availableProviders[e.providerId] = e;
    }
  }

  UserInfo? getUserInfo(String providerId) {
    return connectedProviders[providerId];
  }

  Future<void> connect(AvailableAuthProvider providerInfo, BuildContext context) async {
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

class AvailableAuthProvider {
  final String title;
  final String providerId;
  final IconData iconData;
  final BaseSocialAuthApi authApi;

  AvailableAuthProvider({
    required this.title,
    required this.iconData,
    required this.providerId,
    required this.authApi,
  });
}

// if (connectedProviders.isNotEmpty) {
//   availableProviders['password'] = AvailableAuthProvider(
//     providerId: 'password',
//     title: 'Email',
//     iconData: Icons.email,
//     connect: (context) async {
//       final inputs = await showTextInputDialog(
//         context: context,
//         textFields: [
//           DialogTextField(
//             hintText: "New password",
//             validator: (String? value) {
//               if (value == null) return "Must not empty";
//               if (value.length < 6) return "Must be more than 6 characters";
//               return null;
//             },
//           ),
//         ],
//       );

//       if (inputs != null) {
//         final password = inputs[0];
//         await FirebaseAuth.instance.currentUser?.updatePassword(password);
//         return FirebaseAuth.instance.currentUser;
//       }

//       return null;
//     },
//   );
// }

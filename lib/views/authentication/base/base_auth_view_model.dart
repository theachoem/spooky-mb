// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/api/cloud_firestore/users_firestore_database.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/core/routes/sp_router.dart' as r;
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/views/authentication/base/auth_provider_datas.dart';

class BaseAuthViewModel extends BaseViewModel {
  List<AuthProviderDatas> availableProviders = AuthProviderDatas.items;
  UsersFirestoreDatabase usersDatabase = UsersFirestoreDatabase();

  Future<void> continueWithSocial({
    required AuthProviderDatas provider,
    required BuildContext context,
  }) async {
    User? connectedUser = await MessengerService.instance.showLoading<User>(
      future: () => provider.authApi.connect(),
      context: context,
      debugSource: "debugSource",
    );

    // double check, in case connect() is fail due to already connect
    if (connectedUser == null) {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pushReplacementNamed(r.SpRouter.user.path);
        return;
      } else {
        MessengerService.instance.showSnackBar(
          provider.authApi.errorMessage ?? "Connect unsuccessfully",
          success: false,
          showAction: false,
        );
        return;
      }
    }

    Navigator.of(context).pushReplacementNamed(r.SpRouter.user.path);
  }
}

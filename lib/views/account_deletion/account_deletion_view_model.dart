// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/views/authentication/base/auth_provider_datas.dart';

class AccountDeletionViewModel extends BaseViewModel {
  String? cacheLabel;
  String? errorMessage;

  Future<void> deleteAccount(BuildContext context, String nameToType) async {
    if (validate(nameToType)) {
      OkCancelResult result = await showOkCancelAlertDialog(
        context: context,
        title: tr("alert.are_you_sure_to_delete_account.title"),
        isDestructiveAction: true,
        okLabel: tr("button.delete"),
        message: tr("alert.are_you_sure_to_delete_account.message"),
      );

      if (result == OkCancelResult.ok) {
        var connectedProvoders = FirebaseAuth.instance.currentUser?.providerData.map((e) => e.providerId);
        List<AuthProviderDatas> availableProviders = AuthProviderDatas.items.where((e) {
          return connectedProvoders?.contains(e.providerId) == true;
        }).toList();

        FirebaseAuthException? exception = await processDelete(context, "deletion - first try");
        if (exception?.code == "requires-recent-login") {
          await reAuth(context, availableProviders);
          await processDelete(context, "deletion - second try");
        }
      }
    }
  }

  Future<void> reAuth(BuildContext context, List<AuthProviderDatas> availableProviders) async {
    String? providerId = await showModalActionSheet<String>(
      context: context,
      title: tr("alert.acc_deletion_access_denied.title"),
      message: tr("alert.acc_deletion_access_denied.message"),
      actions: availableProviders.map((e) {
        return SheetAction(
          icon: e.iconData,
          key: e.providerId,
          label: e.title,
        );
      }).toList(),
    );

    List<AuthProviderDatas> result = availableProviders.where((e) => e.providerId == providerId).toList();
    AuthCredential? credential = result.isEmpty ? null : await result.first.authApi.getCredential();

    if (credential == null) return;
    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
  }

  Future<FirebaseAuthException?> processDelete(
    BuildContext context, [
    String? debugSource,
  ]) async {
    FirebaseAuthException? exception;
    if (kDebugMode) print("debugSource: $debugSource");
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      if (e is FirebaseAuthException) exception = e;
    }

    if (exception != null) {
      return exception;
    } else {
      Phoenix.rebirth(context);
      return null;
    }
  }

  bool validate(String nameToType) {
    String t1 = cacheLabel ?? "";
    String t2 = nameToType;
    bool validated = t1 == t2;

    errorMessage = !validated ? tr("step.delete_account.step2.message", namedArgs: {"NAME": nameToType}) : null;
    notifyListeners();

    return validated;
  }
}

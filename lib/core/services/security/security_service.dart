library security_service;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:local_auth/local_auth.dart';
import 'package:spooky/core/storages/local_storages/security/security_storage.dart';
import 'package:spooky/core/types/biometrics_lock_flow_type.dart';
import 'package:spooky/core/types/lock_type.dart';

part './biometrics_service.dart';
part './password_service.dart';
part './pin_code_service.dart';
part './security_informations.dart';
part './base_lock_service.dart';

class SecurityService {
  static Future<void> initialize() => _lockInfo.initialize();
  static final _SecurityInformations _lockInfo = _SecurityInformations();

  _SecurityInformations get lockInfo => _lockInfo;

  _PinCodeService get pinCodeService => _PinCodeService(lockInfo);
  _BiometricsService get biometricsService => _BiometricsService(lockInfo);
  _PasswordService get passwordService => _PasswordService(lockInfo);

  Future<void> showLockIfHas(BuildContext? context) async {
    if (context == null) return;

    SecurityObject? value = await lockInfo.getLock();
    LockType? type = value?.type;
    String? secret = value?.secret;
    if (secret == null || type == null) {
      lockInfo._storage.clearLock();
      return;
    }

    switch (type) {
      case LockType.pin:
        await _showPinLock(
          context: context,
          secret: secret,
        );
        break;
      // TODO: password lock
      case LockType.password:
        break;
      case LockType.biometric:
        await _showBiometricsLock(context, BiometricsLockFlowType.unlock);
        break;
    }
  }

  Future<void> _showBiometricsLock(BuildContext context, BiometricsLockFlowType flow) async {
    if (lockInfo.hasLocalAuth) {
      bool authenticated = await lockInfo._localAuth.authenticate(localizedReason: "Unlock to open the app");
      if (authenticated) {
        switch (flow) {
          case BiometricsLockFlowType.set:
            String matchedSecret = await setPinLock(context);
            lockInfo._storage.setLock(LockType.biometric, matchedSecret);
            break;
          case BiometricsLockFlowType.remove:
            lockInfo._storage.clearLock();
            break;
          case BiometricsLockFlowType.unlock:
            break;
        }
      } else {
        SecurityObject? lock = await lockInfo.getLock();
        if (lock == null) return;
        switch (flow) {
          case BiometricsLockFlowType.set:
            break;
          case BiometricsLockFlowType.remove:
            removeLock(context);
            break;
          case BiometricsLockFlowType.unlock:
            _showPinLock(context: context, secret: lock.secret!);
            break;
        }
      }
    }
  }

  Future<void> _showPinLock({
    required BuildContext context,
    required String secret,
    bool canCancel = false,
  }) async {
    Completer<bool> confirmOwnership = Completer();
    screenLock(
      context: context,
      correctString: secret,
      canCancel: canCancel,
      didUnlocked: () => confirmOwnership.complete(true),
    );
    await confirmOwnership.future;
    Navigator.of(context).pop();
  }

  Future<void> removeBiometricsLock(BuildContext context) async {
    return _showBiometricsLock(context, BiometricsLockFlowType.remove);
  }

  Future<void> setBiometricsLock(BuildContext context) async {
    return _showBiometricsLock(context, BiometricsLockFlowType.set);
  }

  Future<String> setPinLock(BuildContext context, {int digit = 4}) async {
    Completer<String> confirmNewPassword = Completer();

    SecurityObject? lock = await lockInfo.getLock();
    if (lock?.type == LockType.pin && lock?.secret != null) {
      await _showPinLock(
        context: context,
        secret: lock!.secret!,
        canCancel: true,
      );
    }

    screenLock(
      digits: 4,
      context: context,
      correctString: '',
      title: const HeadingTitle(text: 'Please enter new passcode.'),
      confirmation: true,
      didConfirmed: (matchedSecret) {
        confirmNewPassword.complete(matchedSecret);
      },
    );

    String matchedSecret = await confirmNewPassword.future;
    Navigator.of(context).maybePop();

    try {
      lockInfo._storage.setLock(LockType.pin, matchedSecret);
      return matchedSecret;
    } catch (e) {
      return matchedSecret;
    }
  }

  Future<void> removeLock(BuildContext context) async {
    SecurityObject? value = await lockInfo.getLock();
    LockType? type = value?.type;
    String? secret = value?.secret;

    if (type == null) return;
    switch (type) {
      case LockType.pin:
        if (secret == null) break;
        await _showPinLock(
          context: context,
          secret: secret,
          canCancel: true,
        );
        break;
      // TODO: implement password
      case LockType.password:
        break;
      case LockType.biometric:
        await _showBiometricsLock(context, BiometricsLockFlowType.remove);
        break;
    }
    await lockInfo.clear();
  }
}

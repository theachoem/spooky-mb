import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:local_auth/local_auth.dart';
import 'package:spooky/core/storages/local_storages/security/security_storage.dart';
import 'package:spooky/core/types/biometrics_lock_flow_type.dart';
import 'package:spooky/core/types/lock_type.dart';

class SecurityService {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static final SecurityStorage _storage = SecurityStorage();

  static bool? _hasFaceID;
  static bool? _hasFingerprint;
  static bool? _hasIris;

  bool get hasFaceID => _hasFaceID ?? false;
  bool get hasFingerprint => _hasFingerprint ?? false;
  bool get hasIris => _hasIris ?? false;

  bool get hasLocalAuth => hasFaceID || hasFingerprint || hasIris;

  static Future<void> initialize() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics && await _localAuth.isDeviceSupported();
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      _hasFaceID = availableBiometrics.contains(BiometricType.face);
      _hasFaceID = availableBiometrics.contains(BiometricType.fingerprint);
      _hasIris = availableBiometrics.contains(BiometricType.iris);
    }
  }

  Future<void> _authentication(
    BuildContext context,
    BiometricsLockFlowType flow,
  ) async {
    if (hasLocalAuth) {
      bool authenticated = await _localAuth.authenticate(localizedReason: "Unlock to open the app");
      if (authenticated) {
        Navigator.of(context).maybePop();
        switch (flow) {
          case BiometricsLockFlowType.set:
            _storage.setLock(LockType.biometric, null);
            break;
          case BiometricsLockFlowType.remove:
            _storage.clearLock();
            break;
          case BiometricsLockFlowType.unlock:
            break;
        }
      }
    }
  }

  Future<void> showLockIfHas(BuildContext? context) async {
    if (context == null) return;

    SecurityObject? value = await getLock();
    LockType? type = value?.type;
    String? secret = value?.secret;
    if (type == null) return;

    switch (type) {
      case LockType.pin:
        await _showPinLock(
          context: context,
          secret: secret,
        );
        break;
      // TODO: password lock
      case LockType.password:
        if (secret == null) _storage.clearLock();
        break;
      case LockType.biometric:
        _showBiometricsLock(context, BiometricsLockFlowType.unlock);
        break;
    }
  }

  void _showBiometricsLock(BuildContext context, BiometricsLockFlowType flow) {
    screenLock(
      context: context,
      correctString: '',
      customizedButtonChild: Icon(Icons.fingerprint),
      customizedButtonTap: () => _authentication(context, flow),
      didOpened: () => _authentication(context, flow),
    );
  }

  Future<void> _showPinLock({
    required BuildContext context,
    required String? secret,
    bool canCancel = false,
  }) async {
    if (secret == null) {
      _storage.clearLock();
      return;
    }

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

  Future<void> setBiometricsLock(BuildContext context) async {
    return _showBiometricsLock(context, BiometricsLockFlowType.set);
  }

  Future<bool> setPinLock(BuildContext context, {int digit = 4}) async {
    Completer<String> confirmNewPassword = Completer();

    SecurityObject? lock = await getLock();
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
      _storage.setLock(LockType.pin, matchedSecret);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeLock(BuildContext context) async {
    SecurityObject? value = await getLock();
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
        _showBiometricsLock(context, BiometricsLockFlowType.remove);
        break;
    }
    await clear();
  }

  Future<SecurityObject?> getLock() => _storage.getLock();
  Future<void> clear() => _storage.clearLock();
}

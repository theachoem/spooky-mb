library security_service;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:local_auth/local_auth.dart';
import 'package:open_settings/open_settings.dart';
import 'package:spooky/ui/views/lock/types/lock_flow_type.dart';
import 'package:spooky/utils/util_widgets/screen_lock.dart';
import 'package:spooky/core/storages/local_storages/security/security_storage.dart';
import 'package:spooky/core/types/lock_type.dart';
import 'package:local_auth/error_codes.dart' as code;

part './methods/biometrics_service.dart';
part './methods/password_service.dart';
part './methods/pin_code_service.dart';
part './helpers/security_informations.dart';
part './helpers/security_service_mixin.dart';
part './methods/base_lock_service.dart';
part './helpers/options.dart';

class SecurityService with _SecurityServiceMixin {
  static Future<void> initialize() => _lockInfo.initialize();

  static final _SecurityInformations _lockInfo = _SecurityInformations();
  _SecurityInformations get lockInfo => _lockInfo;

  _PinCodeService get pinCodeService => _PinCodeService(lockInfo);
  _BiometricsService get biometricsService => _BiometricsService(lockInfo);
  _PasswordService get passwordService => _PasswordService(lockInfo);

  Future<bool> showLockIfHas(BuildContext context) async {
    SecurityObject? object = await getObject(lockInfo);
    if (object == null) return true;
    return unlock(context: context, type: object.type);
  }

  Future<bool> unlock({
    required BuildContext context,
    required LockType type,
    LockFlowType flowType = LockFlowType.unlock,
  }) async {
    SecurityObject? object = await getObject(lockInfo);
    if (object == null) return true;

    switch (type) {
      case LockType.pin:
        return pinCodeService.unlock(_PinCodeOptions(
          context: context,
          object: object,
          lockType: LockType.pin,
          flowType: flowType,
          next: (bool authenticated) async => authenticated,
        ));
      case LockType.password:
        return passwordService.unlock(_PasswordOptions(
          context: context,
          object: object,
          lockType: LockType.password,
          flowType: flowType,
          next: (bool authenticated) async => authenticated,
        ));
      case LockType.biometric:
        return biometricsService.unlock(_BiometricsOptions(
          context: context,
          object: object,
          lockType: LockType.biometric,
          flowType: flowType,
          next: (bool authenticated) async => authenticated,
        ));
    }
  }

  Future<void> set({
    required BuildContext context,
    required LockType type,
  }) async {
    SecurityObject? object = await getObject(lockInfo);
    if (object != null) {
      return update(context: context, type: type);
    }

    switch (type) {
      case LockType.pin:
        await pinCodeService.set(_PinCodeOptions(
          context: context,
          object: null,
          lockType: LockType.pin,
          flowType: LockFlowType.set,
          next: (bool authenticated) async => authenticated,
        ));
        break;
      case LockType.password:
        await passwordService.set(_PasswordOptions(
          context: context,
          object: null,
          lockType: LockType.password,
          flowType: LockFlowType.set,
          next: (bool authenticated) async => authenticated,
        ));
        break;
      case LockType.biometric:
        await biometricsService.set(_BiometricsOptions(
          context: context,
          object: null,
          flowType: LockFlowType.set,
          lockType: LockType.biometric,
          next: (bool authenticated) async {
            if (authenticated) {
              return pinCodeService.set(_PinCodeOptions(
                context: context,
                object: null,
                lockType: LockType.biometric,
                flowType: LockFlowType.set,
                next: (bool authenticated) async => authenticated,
              ));
            } else {
              return authenticated;
            }
          },
        ));
        break;
    }
  }

  /// NOTE: no need to update for biometric
  // to update: unlock -> remove -> set
  Future<void> update({
    required BuildContext context,
    required LockType type,
  }) async {
    SecurityObject? object = await getObject(lockInfo);
    if (object == null) return;
    await remove(context: context, type: object.type);

    // make sure object = null before call set
    SecurityObject? removedObject = await getObject(lockInfo);
    if (removedObject == null) {
      await set(context: context, type: type);

      // in case it fail, we set lock
      SecurityObject? setObject = await getObject(lockInfo);
      if (setObject == null) {
        lockInfo._storage.setLock(object.type, object.secret);
      }
    }
  }

  Future<bool> remove({
    required BuildContext context,
    required LockType type,
  }) async {
    SecurityObject? object = await getObject(lockInfo);
    if (object == null) return true;

    switch (type) {
      case LockType.pin:
        return pinCodeService.remove(_PinCodeOptions(
          context: context,
          object: object,
          lockType: LockType.pin,
          flowType: LockFlowType.remove,
          next: (bool authenticated) async => authenticated,
        ));
      case LockType.password:
        return passwordService.remove(_PasswordOptions(
          context: context,
          object: object,
          lockType: LockType.password,
          flowType: LockFlowType.remove,
          next: (bool authenticated) async => authenticated,
        ));
      case LockType.biometric:
        return biometricsService.remove(_BiometricsOptions(
          context: context,
          object: object,
          lockType: LockType.biometric,
          flowType: LockFlowType.remove,
          next: (bool authenticated) async {
            if (!authenticated) {
              bool _authenticated = await pinCodeService.unlock(_PinCodeOptions(
                context: context,
                object: null,
                lockType: LockType.biometric,
                flowType: LockFlowType.remove,
                next: (bool authenticated) async => authenticated,
              ));
              if (_authenticated) await lockInfo._storage.clearLock();
              return _authenticated;
            } else {
              return authenticated;
            }
          },
        ));
    }
  }
}

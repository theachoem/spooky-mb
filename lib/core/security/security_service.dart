library security_service;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:local_auth/local_auth.dart';
import 'package:open_settings/open_settings.dart';
import 'package:spooky/utils/util_widgets/screen_lock.dart';
import 'package:spooky/core/storages/local_storages/security/security_storage.dart';
import 'package:spooky/core/types/lock_type.dart';
import 'package:local_auth/error_codes.dart' as code;

part './local_services/biometrics_service.dart';
part './local_services/password_service.dart';
part './local_services/pin_code_service.dart';
part './others/security_informations.dart';
part './others/security_service_mixin.dart';
part './local_services/base_lock_service.dart';
part './others/options.dart';

class SecurityService with _SecurityServiceMixin {
  static Future<void> initialize() => _lockInfo.initialize();

  static final _SecurityInformations _lockInfo = _SecurityInformations();
  _SecurityInformations get lockInfo => _lockInfo;

  _PinCodeService get pinCodeService => _PinCodeService(lockInfo);
  _BiometricsService get biometricsService => _BiometricsService(lockInfo);
  _PasswordService get passwordService => _PasswordService(lockInfo);

  Future<void> showLockIfHas(BuildContext? context) async {
    if (context == null) return;
    SecurityObject? object = await getObject(lockInfo);
    if (object == null) return;
    return unlock(context: context, type: object.type);
  }

  Future<void> unlock({
    required BuildContext context,
    required LockType type,
  }) async {
    SecurityObject? object = await getObject(lockInfo);
    if (object == null) return;

    switch (type) {
      case LockType.pin:
        await pinCodeService.unlock(_PinCodeOptions(
          context: context,
          object: object,
          lockType: LockType.pin,
          next: (bool authenticated) async => authenticated,
        ));
        break;
      case LockType.password:
        await passwordService.unlock(_PasswordOptions(
          context: context,
          object: object,
          lockType: LockType.password,
          next: (bool authenticated) async => authenticated,
        ));
        break;
      case LockType.biometric:
        await biometricsService.unlock(_BiometricsOptions(
          context: context,
          object: object,
          lockType: LockType.biometric,
          next: (bool authenticated) async => authenticated,
        ));
        break;
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
          next: (bool authenticated) async => authenticated,
        ));
        break;
      case LockType.password:
        await passwordService.set(_PasswordOptions(
          context: context,
          object: null,
          lockType: LockType.password,
          next: (bool authenticated) async => authenticated,
        ));
        break;
      case LockType.biometric:
        await biometricsService.set(_BiometricsOptions(
          context: context,
          object: null,
          lockType: LockType.biometric,
          next: (bool authenticated) async {
            if (authenticated) {
              return pinCodeService.set(_PinCodeOptions(
                context: context,
                object: null,
                lockType: LockType.biometric,
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

  Future<void> update({
    required BuildContext context,
    required LockType type,
  }) async {
    SecurityObject? object = await getObject(lockInfo);
    if (object == null) return;

    switch (type) {
      case LockType.pin:
        await pinCodeService.update(_PinCodeOptions(
          context: context,
          object: object,
          lockType: LockType.pin,
          next: (bool authenticated) async => authenticated,
        ));
        break;
      case LockType.password:
        await passwordService.update(_PasswordOptions(
          context: context,
          object: object,
          lockType: LockType.password,
          next: (bool authenticated) async => authenticated,
        ));
        break;
      case LockType.biometric:
        await biometricsService.update(_BiometricsOptions(
          context: context,
          object: object,
          lockType: LockType.biometric,
          next: (bool authenticated) async => authenticated,
        ));
        break;
    }
  }

  Future<void> remove({
    required BuildContext context,
    required LockType type,
  }) async {
    SecurityObject? object = await getObject(lockInfo);
    if (object == null) return;

    switch (type) {
      case LockType.pin:
        await pinCodeService.remove(_PinCodeOptions(
          context: context,
          object: object,
          lockType: LockType.pin,
          next: (bool authenticated) async => authenticated,
        ));
        break;
      case LockType.password:
        await passwordService.remove(_PasswordOptions(
          context: context,
          object: object,
          lockType: LockType.password,
          next: (bool authenticated) async => authenticated,
        ));
        break;
      case LockType.biometric:
        await biometricsService.remove(_BiometricsOptions(
          context: context,
          object: object,
          lockType: LockType.biometric,
          next: (bool authenticated) async {
            if (!authenticated) {
              bool _authenticated = await pinCodeService.unlock(_PinCodeOptions(
                context: context,
                object: null,
                lockType: LockType.biometric,
                next: (bool authenticated) async => authenticated,
              ));
              if (_authenticated) await lockInfo._storage.clearLock();
              return _authenticated;
            } else {
              return authenticated;
            }
          },
        ));
        break;
    }
  }
}

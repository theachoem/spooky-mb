import 'package:flutter/material.dart';
import 'package:spooky/core/services/security_service.dart';
import 'package:spooky/core/storages/local_storages/security/security_storage.dart';
import 'package:stacked/stacked.dart';

class SecurityViewModel extends BaseViewModel {
  final SecurityService service = SecurityService();
  late final ValueNotifier<LockType?> lockedTypeNotifier;

  SecurityViewModel() {
    lockedTypeNotifier = ValueNotifier(null);
    service.getLock().then((e) {
      lockedTypeNotifier.value = e?.type;
    });
  }

  @override
  void dispose() {
    lockedTypeNotifier.dispose();
    super.dispose();
  }
}

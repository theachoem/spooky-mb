import 'package:flutter/material.dart';
import 'package:spooky/core/storages/local_storages/lock_storage.dart';
import 'package:stacked/stacked.dart';

class SecurityViewModel extends BaseViewModel {
  final LockStorage storage = LockStorage();
  late final ValueNotifier<LockedType?> lockedTypeNotifier;

  SecurityViewModel() {
    lockedTypeNotifier = ValueNotifier(null);
    storage.readEnum().then((type) {
      lockedTypeNotifier.value = type;
    });
  }
}

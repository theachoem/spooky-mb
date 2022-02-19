import 'package:flutter/material.dart';
import 'package:spooky/core/services/security_service.dart';
import 'package:spooky/core/storages/local_storages/security/lock_life_circle_duration_storage.dart';
import 'package:spooky/core/types/lock_type.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:stacked/stacked.dart';

class SecurityViewModel extends BaseViewModel {
  final SecurityService service = SecurityService();
  final LockLifeCircleDurationStorage lockLifeCircleDurationStorage = LockLifeCircleDurationStorage();

  late final ValueNotifier<LockType?> lockedTypeNotifier;
  late final ValueNotifier<int> lockLifeCircleDurationNotifier;

  SecurityViewModel() {
    lockedTypeNotifier = ValueNotifier(null);
    lockLifeCircleDurationNotifier = ValueNotifier(AppConstant.lockLifeDefaultCircleDuration.inSeconds);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      load();
    });
  }

  Future<void> load() async {
    service.getLock().then((e) {
      lockedTypeNotifier.value = e?.type;
    });
    lockLifeCircleDurationStorage.read().then((value) {
      if (value == null) return;
      lockLifeCircleDurationNotifier.value = value;
    });
  }

  @override
  void dispose() {
    lockedTypeNotifier.dispose();
    lockLifeCircleDurationNotifier.dispose();
    super.dispose();
  }

  void setLockLifeCircleDuration(int? second) {
    lockLifeCircleDurationStorage.write(second);
    load();
  }
}

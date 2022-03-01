import 'package:flutter/material.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/storages/local_storages/security/lock_life_circle_duration_storage.dart';
import 'package:spooky/core/types/lock_type.dart';
import 'package:spooky/utils/constants/app_constant.dart';

class SecurityViewModel extends ChangeNotifier with WidgetsBindingObserver {
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
    WidgetsBinding.instance?.addObserver(this);
  }

  Future<void> load() async {
    service.lockInfo.getLock().then((e) {
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
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  void setLockLifeCircleDuration(int? second) {
    lockLifeCircleDurationStorage.write(second);
    load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // user may close app to add finger print,
        // we call to refresh it,
        SecurityService.initialize().then((value) {
          notifyListeners();
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}

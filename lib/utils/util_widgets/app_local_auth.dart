import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/storages/local_storages/security/lock_life_circle_duration_storage.dart';
import 'package:spooky/core/story_writers/auto_save_story_writer.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';

class AppLocalAuth extends StatefulWidget {
  const AppLocalAuth({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  static AppLocalAuthState? of(BuildContext context) {
    return context.findAncestorStateOfType<AppLocalAuthState>();
  }

  @override
  State<AppLocalAuth> createState() => AppLocalAuthState();
}

class AppLocalAuthState extends State<AppLocalAuth> with WidgetsBindingObserver, ScheduleMixin {
  SecurityService service = SecurityService();

  // avoid push same unlock pin route
  bool hasPinLockScreenOnState = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      SecurityService.initialize();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => showLock());
    WidgetsBinding.instance.addObserver(this);
  }

  bool get shouldLock {
    // DURING IMAGE PICKING
    bool skipAlert = AutoSaveStoryWriter.instance.skipAlert;
    return !skipAlert;
  }

  Future<void> showLock() async {
    if (!shouldLock) return;

    if (hasPinLockScreenOnState) return;
    hasPinLockScreenOnState = true;
    await service.showLockIfHas(context);
    hasPinLockScreenOnState = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.resumed:
        cancelTimer(const ValueKey("SecurityService"));
        break;
      case AppLifecycleState.paused:
        LockLifeCircleDurationStorage().read().then((e) {
          scheduleAction(
            () => showLock(),
            key: const ValueKey("SecurityService"),
            duration: Duration(seconds: e ?? AppConstant.lockLifeDefaultCircleDuration.inSeconds),
          );
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

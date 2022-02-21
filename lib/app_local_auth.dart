import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/services/open_file_url_service.dart';
import 'package:spooky/core/storages/local_storages/security/lock_life_circle_duration_storage.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';

class AppLocalAuth extends StatefulWidget {
  const AppLocalAuth({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  static _AppLocalAuthState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppLocalAuthState>();
  }

  @override
  State<AppLocalAuth> createState() => _AppLocalAuthState();
}

class _AppLocalAuthState extends State<AppLocalAuth> with WidgetsBindingObserver, ScheduleMixin {
  SecurityService service = SecurityService();

  // avoid push same unlock pin route
  bool hasPinLockScreenOnState = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      SecurityService.initialize();
    }
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      OpenFileUrlService.getOpenFileUrl(context);
      showLock();
    });
    WidgetsBinding.instance?.addObserver(this);
  }

  Future<void> showLock() async {
    if (hasPinLockScreenOnState) return;
    hasPinLockScreenOnState = true;
    await service.showLockIfHas(context);
    hasPinLockScreenOnState = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        cancelTimer(ValueKey("SecurityService"));
        OpenFileUrlService.getOpenFileUrl(context);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        LockLifeCircleDurationStorage().read().then((e) {
          scheduleAction(
            () => showLock(),
            key: ValueKey("SecurityService"),
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

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/services/toast_service.dart';
import 'package:spooky/core/storages/local_storages/developer_mode_storage.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';

class SpAppVersion extends StatefulWidget {
  const SpAppVersion({
    Key? key,
  }) : super(key: key);

  @override
  State<SpAppVersion> createState() => _SpAppVersionState();
}

class _SpAppVersionState extends State<SpAppVersion> with ScheduleMixin {
  late final ValueNotifier<int> counterNotifier;
  final DeveloperModeStorage storage = DeveloperModeStorage();

  ValueNotifier<bool>? get developerModeNotifier => App.of(context)?.developerModeNotifier;

  @override
  void initState() {
    super.initState();
    setModeFromStorage();
    counterNotifier = ValueNotifier(0);
    counterNotifier.addListener(() {
      scheduleAction(
        () => counterNotifier.value = 0,
        duration: Duration(seconds: 1),
      );
    });
  }

  Future<void> setModeFromStorage() async {
    return storage.read().then((value) {
      return setDeveloperMode(value == true);
    });
  }

  void setDeveloperMode(bool value) {
    App.of(context)?.developerModeNotifier.value = value;
    storage.write(value);
  }

  @override
  void dispose() {
    counterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        PackageInfo? info = snapshot.data;
        if (info == null) return SizedBox.shrink();
        return GestureDetector(
          onTap: () {
            int left = 20 - counterNotifier.value;
            counterNotifier.value = counterNotifier.value + 1;
            if (developerModeNotifier?.value == true) {
              ToastService.show("You are already a developer!");
            } else if (left <= 10) {
              if (left < 0) {
                ToastService.close();
                ToastService.show("You are now a developer!");
                setDeveloperMode(true);
              } else {
                ToastService.show("You are now $left steps away from being a developer");
              }
            }
          },
          onLongPress: () {
            if (developerModeNotifier?.value == true) {
              setDeveloperMode(false);
              ToastService.show("Developer mode off");
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(ConfigConstant.margin2),
            child: Text(
              info.version + " (" + info.buildNumber + ")",
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

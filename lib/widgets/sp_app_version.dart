import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/services/toast_service.dart';
import 'package:spooky/providers/developer_mode_provider.dart';
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
  DeveloperModeProvider get developerModeReader => context.read<DeveloperModeProvider>();

  @override
  void initState() {
    super.initState();
    counterNotifier = ValueNotifier(0);
    counterNotifier.addListener(() {
      scheduleAction(
        () => counterNotifier.value = 0,
        duration: const Duration(seconds: 1),
      );
    });
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
        if (info == null) return const SizedBox.shrink();
        return ListTile(
          onLongPress: () {
            if (developerModeReader.developerModeOn) {
              developerModeReader.set(false);
              ToastService.show("Developer mode off");
            }
          },
          onTap: () {
            int left = 20 - counterNotifier.value;
            counterNotifier.value = counterNotifier.value + 1;
            if (developerModeReader.developerModeOn) {
              ToastService.show("You are already a developer!");
            } else if (left <= 10) {
              if (left < 0) {
                ToastService.close();
                developerModeReader.set(true);
                showOkAlertDialog(
                  context: context,
                  title: "You are now a developer!",
                  barrierDismissible: false,
                );
              } else {
                ToastService.show("You are now $left steps away from being a developer");
              }
            }
          },
          leading: const SizedBox(height: 40, child: Icon(Icons.build)),
          title: const Text('Version'),
          subtitle: Text(
            "${info.version}.${info.buildNumber}",
          ),
        );
      },
    );
  }
}

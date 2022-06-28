import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/notification_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';

class NotificationPermissionButton extends StatelessWidget {
  const NotificationPermissionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(builder: (context, provider, child) {
      return SpAnimatedIcons(
        firstChild: SpIconButton(
          icon: Icon(
            Icons.warning,
            color: M3Color.dayColorsOf(context)[1],
          ),
          onPressed: () => provider.requestPermission(context),
        ),
        secondChild: const SizedBox.shrink(),
        showFirst: !provider.isAllow,
      );
    });
  }
}

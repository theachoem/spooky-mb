import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/in_app_update_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';

class InAppUpdateButton extends StatelessWidget {
  const InAppUpdateButton({
    Key? key,
    this.child = const SizedBox.shrink(),
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Consumer<InAppUpdateProvider>(
      child: child,
      builder: (context, provider, child) {
        return SpAnimatedIcons(
          firstChild: SpIconButton(
            icon: Icon(Icons.system_update, color: M3Color.of(context).error),
            onPressed: () => provider.update(),
          ),
          secondChild: child!,
          showFirst: provider.isUpdateAvailable,
        );
      },
    );
  }
}

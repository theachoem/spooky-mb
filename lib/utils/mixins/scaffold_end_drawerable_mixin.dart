import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';

mixin ScaffoldEndDrawableMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  Widget buildDrawer(BuildContext context);

  Widget buildMoreButton([
    IconData icon = Icons.more_vert,
    void Function()? onPressed,
  ]) {
    return SpIconButton(
      icon: SpAnimatedIcons(
        firstChild: Icon(icon),
        secondChild: const Icon(Icons.clear),
        showFirst: scaffoldkey.currentState?.isEndDrawerOpen == true,
      ),
      onPressed: () {
        if (scaffoldkey.currentState?.isEndDrawerOpen == true) return;
        scaffoldkey.currentState?.openEndDrawer();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_icon_button.dart';

mixin ScaffoldEndDrawableMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get endDrawerScaffoldKey => _scaffoldkey;

  Widget buildEndDrawer(BuildContext context);

  Widget buildEndDrawerButton([
    IconData icon = Icons.more_vert,
    void Function()? onPressed,
  ]) {
    return SpIconButton(
      icon: Icon(icon),
      onPressed: () {
        if (endDrawerScaffoldKey.currentState?.isEndDrawerOpen == true) return;
        endDrawerScaffoldKey.currentState?.openEndDrawer();
      },
    );
  }
}

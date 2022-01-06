import 'package:flutter/material.dart';

mixin ScaffoldStateMixin<T extends StatefulWidget> on State<T> {
  late ValueNotifier<bool> isSpBottomSheetOpenNotifer;
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController<dynamic>? persistentBottomSheetController;

  @override
  void initState() {
    isSpBottomSheetOpenNotifer = ValueNotifier(false);
    super.initState();
  }

  @override
  void dispose() {
    isSpBottomSheetOpenNotifer.dispose();
    super.dispose();
  }

  Widget buildSpBottomSheetListener({
    required Widget Function(BuildContext context, bool isSpBottomSheetOpen, Widget? child) builder,
    Widget? child,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSpBottomSheetOpenNotifer,
      child: child,
      builder: (context, value, child) {
        return builder(context, value, child);
      },
    );
  }

  void showSpBottomSheet() async {
    isSpBottomSheetOpenNotifer.value = !isSpBottomSheetOpenNotifer.value;
    if (isSpBottomSheetOpenNotifer.value) {
      persistentBottomSheetController = scaffoldkey.currentState?.showBottomSheet((context) {
        return BottomSheet(
          onClosing: () {},
          enableDrag: false,
          builder: (context) {
            return Column(
              children: [
                ListTile(
                  title: Text("Titlel"),
                )
              ],
            );
          },
        );
      });
      persistentBottomSheetController?.closed.then((value) => isSpBottomSheetOpenNotifer.value = false);
    } else {
      persistentBottomSheetController?.close();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isSpBottomSheetOpenNotifer.dispose();
    });
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

  Widget buildSheet(BuildContext context);

  void toggleSpBottomSheet() async {
    MessengerService.instance.clearSnackBars();
    if (!isSpBottomSheetOpenNotifer.value) {
      persistentBottomSheetController = scaffoldkey.currentState?.showBottomSheet((context) {
        return BottomSheet(
          onClosing: () {},
          enableDrag: false,
          builder: (context) {
            return buildSheet(context);
          },
        );
      });
      persistentBottomSheetController?.closed.then((value) => isSpBottomSheetOpenNotifer.value = false);
    } else {
      persistentBottomSheetController?.close();
    }
    isSpBottomSheetOpenNotifer.value = !isSpBottomSheetOpenNotifer.value;
  }

  Widget buildMoreButton([IconData icon = Icons.more_vert]) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSpBottomSheetOpenNotifer,
      builder: (context, value, child) {
        return SpIconButton(
          icon: SpAnimatedIcons(
            firstChild: Icon(icon),
            secondChild: const Icon(Icons.clear),
            showFirst: !isSpBottomSheetOpenNotifer.value,
          ),
          onPressed: () {
            toggleSpBottomSheet();
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_show_hide_animator.dart';

mixin ScaffoldToggleSheetableMixin<T extends StatefulWidget> on State<T> {
  late ValueNotifier<bool> isSpBottomSheetOpenNotifer;
  PersistentBottomSheetController<dynamic>? persistentBottomSheetController;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get sheetScaffoldkey => _scaffoldkey;

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
  Widget buildSheetVisibilityBuilder({
    required Widget Function(BuildContext context, bool isOpen, Widget? child) builder,
    Widget? child,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSpBottomSheetOpenNotifer,
      child: child,
      builder: (context, isOpen, child) {
        return builder(context, isOpen, child);
      },
    );
  }

  Widget buildSheetVisibilityWrapper(
    Widget child, {
    bool reverse = false,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSpBottomSheetOpenNotifer,
      child: child,
      builder: (context, isOpen, child) {
        if (reverse) isOpen = !isOpen;
        return SpShowHideAnimator(
          shouldShow: !isOpen,
          child: child!,
        );
      },
    );
  }

  void toggleSpBottomSheet() async {
    MessengerService.instance.clearSnackBars();
    if (!isSpBottomSheetOpenNotifer.value) {
      persistentBottomSheetController = sheetScaffoldkey.currentState?.showBottomSheet((context) {
        return BottomSheet(
          onClosing: () {},
          enableDrag: false,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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

  Widget buildMoreButton([
    IconData icon = Icons.more_vert,
    void Function()? onPressed,
  ]) {
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
            if (isSpBottomSheetOpenNotifer.value) {
              toggleSpBottomSheet();
            } else {
              if (onPressed != null) {
                onPressed();
              } else {
                toggleSpBottomSheet();
              }
            }
          },
        );
      },
    );
  }
}

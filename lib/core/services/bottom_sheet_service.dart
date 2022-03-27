import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
// import 'package:spooky/app.dart';

class BottomSheetService {
  BottomSheetService._();
  static final BottomSheetService instance = BottomSheetService._();
  // BuildContext? get _context => App.navigatorKey.currentContext;

  Future<T?> showScrollableSheet<T>({
    required BuildContext context,
    required String title,
    required Widget Function(BuildContext context, ScrollController controller) builder,
  }) async {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useRootNavigator: true,
      builder: (context) {
        double height = MediaQuery.of(context).size.height;
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: (height - statusBarHeight) / height,
          builder: (context, controller) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                leading: null,
                title: Text(title),
                actions: const [
                  SpPopButton(forceCloseButton: true),
                ],
              ),
              body: builder(context, controller),
            );
          },
        );
      },
    );
  }
}

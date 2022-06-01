import 'package:flutter/material.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
// import 'package:spooky/app.dart';

class BottomSheetService {
  BottomSheetService._();
  static final BottomSheetService instance = BottomSheetService._();
  // BuildContext? get _context => App.navigatorKey.currentContext;

  Future<T?> showScrollableSheet<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget Function(BuildContext context, ScrollController controller) builder,
    Widget Function(BuildContext context)? bottomNavigationBarBuilder,
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
              extendBody: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                leading: null,
                elevation: 0.0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: M3TextTheme.of(context).bodySmall,
                      ),
                  ],
                ),
                actions: const [
                  SpPopButton(forceCloseButton: true),
                ],
              ),
              bottomNavigationBar: bottomNavigationBarBuilder != null ? bottomNavigationBarBuilder(context) : null,
              body: Column(
                children: [
                  const Divider(height: 1),
                  Expanded(
                    child: builder(context, controller),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

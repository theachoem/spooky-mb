import 'package:flutter/material.dart';
import 'package:spooky/app.dart';

// only use in app.dart
mixin ScaffoldMessengerMixin<T extends StatefulWidget> on State<T> {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? scaffoldFeatureController;
  BuildContext? get _context => App.navigatorKey.currentContext;
  ScaffoldMessengerState? get _state {
    if (_context != null) {
      return ScaffoldMessenger.maybeOf(_context!);
    }
  }

  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>? showSpMaterialBanner(String message) {
    return _state?.showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              MaterialLocalizations.of(_context!).okButtonLabel,
            ),
          ),
        ],
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSpSnackBar(String message, {bool success = true}) {
    clearSpSnackBars();
    return _state?.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        action: SnackBarAction(
          label: MaterialLocalizations.of(_context!).okButtonLabel,
          onPressed: () {},
        ),
      ),
    );
  }

  void clearSpSnackBars() {
    return _state?.clearSnackBars();
  }

  void hideSpCurrentMaterialBanner() {
    return _state?.hideCurrentMaterialBanner();
  }
}

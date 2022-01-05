import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

// only use in app.dart
mixin ScaffoldMessengerMixin<T extends StatefulWidget> on State<T> {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? scaffoldFeatureController;
  BuildContext? get _context => StackedService.navigatorKey?.currentContext;
  ScaffoldMessengerState? get _state {
    if (_context != null) {
      return ScaffoldMessenger.maybeOf(_context!);
    }
  }

  void showSpMaterialBanner(String message) {
    _state?.showMaterialBanner(
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

  void clearSpSnackBars() {
    return _state?.clearSnackBars();
  }

  void hideSpCurrentMaterialBanner() {
    return _state?.hideCurrentMaterialBanner();
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSpSnackBar(String message) {
    clearSpSnackBars();
    scaffoldFeatureController = _state?.showSnackBar(
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
    return scaffoldFeatureController;
  }
}

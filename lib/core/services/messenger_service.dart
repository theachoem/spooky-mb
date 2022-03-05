import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';

class MessengerService {
  MessengerService._();
  static final MessengerService instance = MessengerService._();

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? scaffoldFeatureController;
  BuildContext? get _context => App.navigatorKey.currentContext;
  ScaffoldMessengerState? get _state {
    if (_context != null) {
      return ScaffoldMessenger.maybeOf(_context!);
    }
    return null;
  }

  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>? showMaterialBanner(String message) {
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

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(String message, {bool success = true}) {
    clearSnackBars();
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

  void clearSnackBars() {
    return _state?.clearSnackBars();
  }

  void hideCurrentMaterialBanner() {
    return _state?.hideCurrentMaterialBanner();
  }

  Future<T?> showLoading<T>({
    required Future<T?> Function() future,
    required BuildContext context,
  }) async {
    Completer<T> completer = Completer();
    future().then((value) => completer.complete(value));

    if (!kIsWeb && Platform.isIOS) {
      return showCupertinoDialog<T>(
        context: context,
        builder: (context) => _loadingBuilder<T>(context, completer),
        barrierDismissible: false,
      );
    } else {
      return showDialog<T>(
        context: context,
        builder: (context) => _loadingBuilder<T>(context, completer),
        barrierDismissible: false,
      );
    }
  }

  Widget _loadingBuilder<T>(BuildContext context, Completer<T> future) {
    return FutureBuilder<T>(
      future: future.future.then((value) {
        Navigator.of(context).pop(value);
        return value;
      }),
      builder: (context, snapshot) {
        return AlertDialog(
          content: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}

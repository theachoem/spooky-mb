import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

/// originally [screenLock],
/// copied to update some API.
Future<T?> enhnacedScreenLock<T>({
  required BuildContext context,
  required String correctString,
  ScreenLockConfig screenLockConfig = const ScreenLockConfig(),
  SecretsConfig secretsConfig = const SecretsConfig(),
  InputButtonConfig inputButtonConfig = const InputButtonConfig(),
  bool canCancel = true,
  bool confirmation = false,
  int digits = 4,
  int maxRetries = 0,
  Duration retryDelay = Duration.zero,
  Widget? delayChild,
  void Function()? didUnlocked,
  void Function(int retries)? didError,
  void Function(int retries)? didMaxRetries,
  void Function()? didOpened,
  void Function(String matchedText)? didConfirmed,
  Future<void> Function()? customizedButtonTap,
  Widget? customizedButtonChild,
  Widget? footer,
  Widget? cancelButton,
  Widget? deleteButton,
  Widget title = const HeadingTitle(text: 'Please enter passcode.'),
  Widget confirmTitle = const HeadingTitle(text: 'Please enter confirm passcode.'),
  InputController? inputController,
  bool withBlur = true,
}) {
  return Navigator.push<T>(
    context,
    PageRouteBuilder<T>(
      opaque: false,
      barrierColor: Colors.black.withOpacity(0.8),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secodaryAnimation,
      ) {
        animation.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (didOpened != null) {
              didOpened();
            }
          }
        });
        return ScreenLock(
          correctString: correctString,
          screenLockConfig: screenLockConfig,
          secretsConfig: secretsConfig,
          inputButtonConfig: inputButtonConfig,
          canCancel: canCancel,
          confirmation: confirmation,
          digits: digits,
          maxRetries: maxRetries,
          retryDelay: retryDelay,
          delayChild: delayChild,
          didUnlocked: didUnlocked,
          didError: didError,
          didMaxRetries: didMaxRetries,
          didConfirmed: didConfirmed,
          customizedButtonTap: customizedButtonTap,
          customizedButtonChild: customizedButtonChild,
          footer: footer,
          deleteButton: deleteButton,
          cancelButton: cancelButton,
          title: title,
          confirmTitle: confirmTitle,
          inputController: inputController,
          withBlur: withBlur,
        );
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 2.4),
            end: Offset.zero,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0.0, 2.4),
            ).animate(secondaryAnimation),
            child: child,
          ),
        );
      },
    ),
  );
}

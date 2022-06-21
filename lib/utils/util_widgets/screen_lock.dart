import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:spooky/core/routes/page_routes/screen_lock_route.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/screen_lock_helper.dart';

/// originally [screenLock],
/// copied to update some API.
Future<T?> enhancedScreenLock<T>({
  required BuildContext context,
  required String correctString,
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
  Widget title = const HeadingTitle(text: 'Please enter passcode'),
  Widget confirmTitle = const HeadingTitle(text: 'Please enter confirm passcode'),
  InputController? inputController,
}) {
  ColorScheme colorScheme = M3Color.of(context);
  TextTheme textTheme = M3TextTheme.of(context);

  InputButtonConfig inputButtonConfig = ScreenLockHelper.inputButtonConfig(textTheme, context, colorScheme);
  SecretsConfig secretsConfig = ScreenLockHelper.secretsConfig(colorScheme);
  ScreenLockConfig screenLockConfig = ScreenLockHelper.screenLockConfig(colorScheme, context, textTheme);

  return Navigator.push<T>(
    context,
    ScreenLockRoute(
      barrierColor: screenLockConfig.backgroundColor,
      builder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> _,
      ) {
        animation.addStatusListener((status) {
          if (status == AnimationStatus.completed && didOpened != null) didOpened();
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
          cancelButton: Container(
            margin: const EdgeInsets.all(ConfigConstant.margin0),
            child: FittedBox(
              child: Text("Cancel", style: textTheme.headlineSmall),
            ),
          ),
          title: title,
          confirmTitle: confirmTitle,
          inputController: inputController,
          withBlur: true,
        );
      },
    ),
  );
}

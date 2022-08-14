import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:spooky/core/routes/page_routes/screen_lock_route.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/helpers/screen_lock_helper.dart';

/// originally [screenLock],
/// copied to update some API.
Future<T?> enhancedScreenLock<T>({
  required BuildContext context,
  required String correctString,
  VoidCallback? didUnlocked,
  VoidCallback? didOpened,
  VoidCallback? didCancelled,
  void Function(String matchedText)? didConfirmed,
  void Function(int retries)? didError,
  void Function(int retries)? didMaxRetries,
  VoidCallback? customizedButtonTap,
  bool confirmation = false,
  bool canCancel = true,
  int digits = 4,
  int maxRetries = 0,
  Duration retryDelay = Duration.zero,
  Widget? title,
  Widget? confirmTitle,
  ScreenLockConfig? screenLockConfig,
  SecretsConfig? secretsConfig,
  KeyPadConfig? keyPadConfig,
  DelayBuilderCallback? delayBuilder,
  Widget? customizedButtonChild,
  Widget? footer,
  Widget? cancelButton,
  Widget? deleteButton,
  InputController? inputController,
  bool withBlur = true,
  SecretsBuilderCallback? secretsBuilder,
  bool useLandscape = true,
  ValidationCallback? onValidate,
}) {
  ColorScheme colorScheme = M3Color.of(context);
  TextTheme textTheme = M3TextTheme.of(context);

  KeyPadConfig keyPadConfig = ScreenLockHelper.keyPadConfig(textTheme, context, colorScheme);
  SecretsConfig secretsConfig = ScreenLockHelper.secretsConfig(colorScheme);
  ScreenLockConfig screenLockConfig = ScreenLockHelper.screenLockConfig(colorScheme, context, textTheme);

  title ??= Text(tr("alert.security.enter_passcode"));
  confirmTitle ??= Text(tr("alert.security.enter_confirm_passcode"));

  return Navigator.push<T>(
    context,
    ScreenLockRoute(
      barrierColor: screenLockConfig.backgroundColor,
      builder: (context, animation, secondaryAnimation) => WillPopScope(
        onWillPop: () async => canCancel && didCancelled == null,
        child: ScreenLock(
          correctString: correctString,
          screenLockConfig: screenLockConfig,
          secretsConfig: secretsConfig,
          keyPadConfig: keyPadConfig,
          didCancelled: canCancel ? didCancelled ?? Navigator.of(context).pop : null,
          confirmation: confirmation,
          digits: digits,
          maxRetries: maxRetries,
          retryDelay: retryDelay,
          delayBuilder: delayBuilder,
          didUnlocked: didUnlocked ?? Navigator.of(context).pop,
          didError: didError,
          didMaxRetries: didMaxRetries,
          didConfirmed: didConfirmed,
          didOpened: didOpened,
          customizedButtonTap: customizedButtonTap,
          customizedButtonChild: customizedButtonChild,
          footer: footer,
          deleteButton: deleteButton,
          cancelButton: const Icon(Icons.keyboard_arrow_down),
          title: title,
          confirmTitle: confirmTitle,
          inputController: inputController,
          withBlur: withBlur,
          secretsBuilder: secretsBuilder,
          useLandscape: useLandscape,
          onValidate: onValidate,
        ),
      ),
      // builder: (
      //   BuildContext context,
      //   Animation<double> animation,
      //   Animation<double> _,
      // ) {
      //   animation.addStatusListener((status) {
      //     if (status == AnimationStatus.completed && didOpened != null) didOpened();
      //   });
      //   return ScreenLock(
      //     correctString: correctString,
      //     screenLockConfig: screenLockConfig,
      //     secretsConfig: secretsConfig,
      //     keyPadConfig: keyPadConfig,
      //     didCancelled: () {},
      //     confirmation: confirmation,
      //     digits: digits,
      //     maxRetries: maxRetries,
      //     retryDelay: retryDelay,
      //     didUnlocked: didUnlocked ?? () {},
      //     didError: didError,
      //     didMaxRetries: didMaxRetries,
      //     didConfirmed: didConfirmed,
      //     customizedButtonTap: customizedButtonTap,
      //     customizedButtonChild: customizedButtonChild,
      //     footer: footer,
      //     deleteButton: deleteButton,
      //     cancelButton: Container(
      //       margin: const EdgeInsets.all(ConfigConstant.margin0),
      //       child: FittedBox(
      //         child: Text("Cancel", style: textTheme.headlineSmall),
      //       ),
      //     ),
      //     title: title,
      //     confirmTitle: confirmTitle,
      //     inputController: inputController,
      //     withBlur: true,
      //   );
      // },
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class ScreenLockHelper {
  static Widget dotBuilder(bool enabled, SecretConfig config) {
    return Container(
      width: config.width,
      height: config.height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled ? config.enabledColor : config.disabledColor,
        border: Border.all(width: config.borderSize, color: config.borderColor),
      ),
    );
  }

  static SecretsConfig secretsConfig(ColorScheme colorScheme) {
    return SecretsConfig(
      padding: const EdgeInsets.only(top: 24, bottom: ConfigConstant.objectHeight2),
      secretConfig: SecretConfig(
        borderColor: colorScheme.onBackground,
        enabledColor: colorScheme.onBackground,
        disabledColor: const Color.fromARGB(0, 8, 6, 6),
        width: 12,
        height: 12,
        build: (context, {required config, required enabled}) => ScreenLockHelper.dotBuilder(enabled, config),
      ),
    );
  }

  static ScreenLockConfig screenLockConfig(ColorScheme colorScheme, BuildContext context, TextTheme textTheme) {
    return ScreenLockConfig(
      backgroundColor: colorScheme.background.withOpacity(0.75),
      themeData: Theme.of(context).copyWith(
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            side: BorderSide.none,
            backgroundColor: colorScheme.secondaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: ConfigConstant.circlarRadius2,
            ),
          ).copyWith(overlayColor: MaterialStateProperty.all(Colors.transparent)),
        ),
        textTheme: TextTheme(
          headline1: textTheme.titleLarge?.copyWith(color: colorScheme.onBackground),
          bodyText2: textTheme.headlineSmall?.copyWith(color: colorScheme.onBackground),
        ),
      ),
    );
  }

  static KeyPadConfig keyPadConfig(
    TextTheme textTheme,
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return KeyPadConfig(
      clearOnLongPressed: true,
      buttonConfig: StyledInputConfig(
        textStyle: textTheme.headlineSmall,
        buttonStyle: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Theme.of(context).splashColor),
          foregroundColor: MaterialStateProperty.all(M3Color.of(context).onSurface),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.isNotEmpty) {
                return colorScheme.onBackground.withOpacity(0.1);
              } else {
                return Colors.transparent;
              }
            },
          ),
        ),
      ),
    );
  }
}

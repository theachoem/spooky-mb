import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class ScreenLockHelper {
  static SpAnimatedIcons dotBuilder(bool enabled, SecretConfig config) {
    animatedContainer(Color color) {
      return AnimatedContainer(
        duration: ConfigConstant.fadeDuration,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(width: config.borderSize, color: config.borderColor),
        ),
        width: config.width,
        height: config.height,
      );
    }

    return SpAnimatedIcons(
      showFirst: enabled,
      firstChild: animatedContainer(config.enabledColor),
      secondChild: animatedContainer(config.disabledColor),
    );
  }

  static SecretsConfig secretsConfig(ColorScheme colorScheme) {
    return SecretsConfig(
      secretConfig: SecretConfig(
        borderColor: colorScheme.onBackground,
        enabledColor: colorScheme.onBackground,
        disabledColor: Color.fromARGB(0, 8, 6, 6),
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

  static InputButtonConfig inputButtonConfig(TextTheme textTheme, ColorScheme colorScheme) {
    return InputButtonConfig(
      textStyle: textTheme.headlineSmall?.copyWith(color: colorScheme.secondary),
      buttonStyle: ButtonStyle(
        animationDuration: Duration(microseconds: 10),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
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
    );
  }
}

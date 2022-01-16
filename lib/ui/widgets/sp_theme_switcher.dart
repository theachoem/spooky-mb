import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/initial_theme.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';

class SpThemeSwitcher extends StatelessWidget {
  const SpThemeSwitcher({
    Key? key,
    this.backgroundColor,
    this.color,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SpIconButton(
      icon: getThemeModeIcon(context),
      backgroundColor: backgroundColor ?? M3Color.of(context).primaryContainer,
      onLongPress: () async {
        ThemeMode? result = await showConfirmationDialog(
          context: context,
          title: "Theme",
          initialSelectedActionKey: InitialTheme.of(context)?.mode,
          actions: themeModeActions,
        );
        if (result != null) {
          InitialTheme.of(context)?.setThemeMode(result);
        }
      },
      onPressed: () {
        InitialTheme.of(context)?.toggleThemeMode();
      },
    );
  }

  Widget getThemeModeIcon(BuildContext context) {
    return SpAnimatedIcons(
      duration: ConfigConstant.duration * 3,
      firstChild: Icon(Icons.dark_mode, color: color, key: ValueKey(Brightness.dark)),
      secondChild: Icon(Icons.light_mode, color: color, key: ValueKey(Brightness.light)),
      showFirst: Theme.of(context).colorScheme.brightness == Brightness.dark,
    );
  }

  List<AlertDialogAction<ThemeMode>> get themeModeActions {
    return ThemeMode.values.map((e) {
      return AlertDialogAction(
        key: e,
        label: e.name.capitalize,
      );
    }).toList();
  }
}

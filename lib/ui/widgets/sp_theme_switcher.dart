import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/initial_theme.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';

class SpThemeSwitcher extends StatefulWidget {
  const SpThemeSwitcher({
    Key? key,
    this.backgroundColor,
    this.color,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? color;

  @override
  State<SpThemeSwitcher> createState() => _SpThemeSwitcherState();

  static bool onPress(BuildContext context) {
    return InitialTheme.of(context)?.toggleThemeMode() == true;
  }

  static Future<void> onLongPress(BuildContext context) async {
    ThemeMode? result = await showConfirmationDialog(
      context: context,
      title: "Theme",
      initialSelectedActionKey: InitialTheme.of(context)?.mode,
      actions: themeModeActions,
    );
    if (result != null) {
      InitialTheme.of(context)?.setThemeMode(result);
    }
  }

  static List<AlertDialogAction<ThemeMode>> get themeModeActions {
    return ThemeMode.values.map((e) {
      return AlertDialogAction(
        key: e,
        label: e.name.capitalize,
      );
    }).toList();
  }
}

class _SpThemeSwitcherState extends State<SpThemeSwitcher> {
  bool? _isDarkMode;
  bool get isDarkMode => _isDarkMode ?? Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpIconButton(
      icon: getThemeModeIcon(context),
      backgroundColor: widget.backgroundColor ?? M3Color.of(context).primaryContainer,
      onLongPress: () async {
        await SpThemeSwitcher.onLongPress(context);
      },
      onPressed: () {
        setState(() {
          _isDarkMode = SpThemeSwitcher.onPress(context);
        });
      },
    );
  }

  Widget getThemeModeIcon(BuildContext context) {
    Color _color = widget.color ?? M3Color.of(context).primary;
    return SpAnimatedIcons(
      duration: ConfigConstant.duration * 3,
      firstChild: Icon(Icons.dark_mode, color: _color, key: ValueKey(Brightness.dark)),
      secondChild: Icon(Icons.light_mode, color: _color, key: ValueKey(Brightness.light)),
      showFirst: isDarkMode,
    );
  }
}

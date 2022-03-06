import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/providers/theme_mode_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';

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
    return context.read<ThemeModeProvider>().toggleThemeMode() == true;
  }

  static Future<void> onLongPress(BuildContext context) async {
    String? result = await showConfirmationDialog(
      context: context,
      title: "Theme",
      initialSelectedActionKey: context.read<ThemeModeProvider>().mode.name,
      actions: themeModeActions
        ..add(const AlertDialogAction(
          key: "setting",
          label: "Go to Setting",
          isDefaultAction: true,
        )),
    );
    if (result != null) {
      switch (result) {
        case "setting":
          Navigator.of(context).pushNamed(SpRouter.themeSetting.path);
          break;
        default:
          ThemeMode? themeMode;
          for (ThemeMode element in ThemeMode.values) {
            if (result == element.name) {
              themeMode = element;
              break;
            }
          }
          context.read<ThemeModeProvider>().setThemeMode(themeMode);
          break;
      }
    }
  }

  static List<AlertDialogAction<String>> get themeModeActions {
    return ThemeMode.values.map((e) {
      return AlertDialogAction(
        key: e.name,
        label: e.name.capitalize,
      );
    }).toList();
  }
}

class _SpThemeSwitcherState extends State<SpThemeSwitcher> with ScheduleMixin {
  bool? _isDarkMode;
  bool get isDarkMode => _isDarkMode ?? isDarkModeFromTheme;
  bool get isDarkModeFromTheme => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _isDarkMode = isDarkModeFromTheme;
    });
  }

  @override
  void didUpdateWidget(covariant SpThemeSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    scheduleAction(() {
      if (_isDarkMode != isDarkModeFromTheme) {
        setState(() {
          _isDarkMode = isDarkModeFromTheme;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpIconButton(
      icon: getThemeModeIcon(context),
      backgroundColor: widget.backgroundColor ?? M3Color.of(context).readOnly.surface5,
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
      firstChild: Icon(Icons.dark_mode, color: _color, key: const ValueKey(Brightness.dark)),
      secondChild: Icon(Icons.light_mode, color: _color, key: const ValueKey(Brightness.light)),
      showFirst: isDarkMode,
    );
  }
}

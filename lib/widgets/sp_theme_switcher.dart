import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';

class SpThemeSwitcher extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  SpThemeSwitcher({
    Key? key,
    this.backgroundColor,
    this.color,
  }) : super(key: key);

  final Color? backgroundColor;
  final Color? color;

  @override
  State<SpThemeSwitcher> createState() => _SpThemeSwitcherState();

  static bool onPress(BuildContext context) {
    return context.read<ThemeProvider>().toggleThemeMode() == true;
  }

  static Future<void> onLongPress(BuildContext context) async {
    await showConfirmationDialog(
      context: context,
      title: "Theme",
      initialSelectedActionKey: context.read<ThemeProvider>().themeMode.name,
      actions: themeModeActions
        ..add(const AlertDialogAction(
          key: "setting",
          label: "Go to Setting",
          isDefaultAction: true,
        )),
    ).then((result) {
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
            context.read<ThemeProvider>().setThemeMode(themeMode);
            break;
        }
      }
    });
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
  late final ValueNotifier<bool> isDarkModeNotifier;
  bool get isDarkModeFromTheme {
    try {
      BuildContext context = App.navigatorKey.currentContext ?? this.context;
      return Theme.of(context).brightness == Brightness.dark;
    } catch (e) {
      if (kDebugMode) print("ERROR: $e");
      Brightness? brightness = SchedulerBinding.instance.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      return isDarkMode;
    }
  }

  @override
  void initState() {
    super.initState();
    isDarkModeNotifier = ValueNotifier<bool>(isDarkModeFromTheme);
  }

  @override
  void dispose() {
    isDarkModeNotifier.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SpThemeSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    scheduleAction(() {
      setDarkMode(isDarkModeFromTheme);
    });
  }

  void setDarkMode(bool value) {
    if (value != isDarkModeNotifier.value) {
      isDarkModeNotifier.value = value;
    }
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
        isDarkModeNotifier.value = SpThemeSwitcher.onPress(context);
      },
    );
  }

  Widget getThemeModeIcon(BuildContext context) {
    Color color = widget.color ?? M3Color.of(context).primary;
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return SpAnimatedIcons(
          duration: ConfigConstant.duration * 3,
          firstChild: Icon(Icons.dark_mode, color: color, key: const ValueKey(Brightness.dark)),
          secondChild: Icon(Icons.light_mode, color: color, key: const ValueKey(Brightness.light)),
          showFirst: isDarkMode,
        );
      },
    );
  }
}

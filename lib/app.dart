import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/app_builder.dart';
import 'package:spooky/core/route/sp_route_config.dart';
import 'package:spooky/core/storages/color_storage.dart';
import 'package:spooky/core/storages/nickname_storage.dart';
import 'package:spooky/main.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/ui/views/app_starter/app_starter_view.dart';
import 'package:spooky/ui/views/main/main_view.dart';
import 'package:spooky/utils/mixins/scaffold_messenger_mixin.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  final ThemeMode themeMode;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static _AppState? of(BuildContext context) {
    return context.findAncestorStateOfType<_AppState>();
  }

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with ScaffoldMessengerMixin {
  late final ValueNotifier<String> nicknameNotifier;
  late final ValueNotifier<bool> developerModeNotifier;
  late TextTheme textTheme;

  Color currentSeedColor = M3Color.currentPrimaryColor;
  ThemeData get lightTheme => ThemeConfig.light().themeData;
  ThemeData get darkTheme => ThemeConfig.dark().themeData;

  @override
  void initState() {
    textTheme = ThemeConfig.buildTextTheme();
    nicknameNotifier = ValueNotifier("");
    developerModeNotifier = ValueNotifier(false);
    super.initState();
    NicknameStorage().read().then((value) {
      if (value is String) {
        nicknameNotifier.value = value;
      }
    });
  }

  void setNickname(String value) {
    if (value != nicknameNotifier.value && value.trim().isNotEmpty) {
      nicknameNotifier.value = value;
      NicknameStorage().write(value);
    }
  }

  void clearNickname() {
    NicknameStorage().remove();
    nicknameNotifier.value = "";
  }

  @override
  void dispose() {
    nicknameNotifier.dispose();
    developerModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      themeMode: widget.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: spAppIntiailized ? MainView() : AppStarterView(),
      theme: lightTheme,
      darkTheme: darkTheme,
      builder: (context, child) => AppBuilder(child: child),
      onGenerateRoute: (settings) => SpRouteConfig(context: context, settings: settings).generate(),
    );
  }

  Future<void> updateColor(Color? color) async {
    await ColorStorage().write(color?.value);
    await M3Color.initialize();
    if (color != null) currentSeedColor = color;
    setState(() {});
  }
}

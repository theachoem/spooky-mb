import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/storages/local_storages/developer_mode_storage.dart';
import 'package:spooky/core/types/product_as_type.dart';
import 'package:spooky/providers/theme_provider.dart';

class UserProvider extends ChangeNotifier with WidgetsBindingObserver {
  // debug only
  bool _purchased = false;

  UserProvider() {
    WidgetsBinding.instance.addObserver(this);

    // debug only, should remove in production
    DeveloperModeStorage().read().then((value) {
      _purchased = value == true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    });
  }

  bool purchased(ProductAsType type) {
    return _purchased;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!purchased(ProductAsType.fontBook)) {
      App.navigatorKey.currentContext?.read<ThemeProvider>().resetFontStyle();
    }
  }
}

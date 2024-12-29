import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class UrlOpenerService {
  Future<void> open(
    BuildContext context,
    String url,
  ) async {
    Color? toolbarColor = Theme.of(context).appBarTheme.backgroundColor;
    Color? foregroundColor = Theme.of(context).appBarTheme.foregroundColor;

    await launchUrl(
      Uri.parse(url),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: toolbarColor,
        ),
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: toolbarColor,
        preferredControlTintColor: foregroundColor,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  }
}

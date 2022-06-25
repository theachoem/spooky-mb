library sign_in_view;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/authentication/base/auth_provider_datas.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_theme_switcher.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:spooky/views/authentication/base/base_auth_view_model.dart';
import 'package:spooky/views/authentication/base/auth_flow_type.dart';
export 'package:spooky/views/authentication/base/auth_flow_type.dart';

abstract class BaseAuthView extends StatelessWidget {
  const BaseAuthView({Key? key}) : super(key: key);

  AuthFlowType get flowType;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<BaseAuthViewModel>(
      create: (context) => BaseAuthViewModel(),
      onModelReady: (context, viewMoel) {},
      builder: (context, viewModel, child) {
        return buildScaffold(context, viewModel);
      },
    );
  }

  Widget buildScaffold(BuildContext context, BaseAuthViewModel viewModel) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color backgroundColor;
    Color foregroundColor;
    Color strongForegroundColor;
    SystemUiOverlayStyle systemUiOverlayStyle;

    backgroundColor = M3Color.of(context).primary;
    foregroundColor = M3Color.of(context).onPrimary;
    strongForegroundColor = M3Color.of(context).onPrimary;
    systemUiOverlayStyle = isDarkMode ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: MorphingAppBar(
        leading: SpPopButton(color: foregroundColor),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: systemUiOverlayStyle,
        elevation: 0.0,
        title: const Text(""),
        actions: [
          SpThemeSwitcher(
            backgroundColor: Colors.transparent,
            color: strongForegroundColor,
          ),
          ConfigConstant.sizedBoxW0,
        ],
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        padding: ConfigConstant.layoutPadding.copyWith(top: 100),
        children: [
          ...buildHeader(
            context: context,
            foregroundColor: foregroundColor,
            strongForegroundColor: strongForegroundColor,
          ),
          ConfigConstant.sizedBoxH2,
          ConfigConstant.sizedBoxH2,
          ...viewModel.availableProviders.map((provider) {
            Buttons buttonType;
            switch (provider.type) {
              case AuthProviderType.google:
                buttonType = Buttons.Google;
                break;
              case AuthProviderType.apple:
                buttonType = isDarkMode ? Buttons.Apple : Buttons.AppleDark;
                break;
              case AuthProviderType.facebook:
                buttonType = Buttons.Facebook;
                break;
            }
            return buildAuthButton(
              buttonType: buttonType,
              type: provider.type,
              context: context,
              onPressed: () {
                onAuthPressed(viewModel, provider, context);
              },
            );
          }),
        ],
      ),
    );
  }

  void onAuthPressed(BaseAuthViewModel viewModel, AuthProviderDatas provider, BuildContext context) {
    viewModel.continueWithSocial(
      provider: provider,
      context: context,
    );
  }

  SignInButton buildAuthButton({
    required AuthProviderType type,
    required BuildContext context,
    required Function onPressed,
    required Buttons buttonType,
  }) {
    String label;

    switch (type) {
      case AuthProviderType.google:
        label = "Continue with Google";
        break;
      case AuthProviderType.apple:
        label = "Continue with Apple";
        break;
      case AuthProviderType.facebook:
        label = "Continue with Facebook";
        break;
    }

    return SignInButton(
      buttonType,
      text: label,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
      onPressed: onPressed,
    );
  }

  List<Widget> buildHeader({
    required BuildContext context,
    required Color foregroundColor,
    required Color strongForegroundColor,
  }) {
    return [
      Text(
        "Try something...",
        style: M3TextTheme.of(context).headlineLarge?.copyWith(color: foregroundColor),
      ),
      Text(
        "Different",
        style:
            M3TextTheme.of(context).headlineLarge!.copyWith(fontWeight: FontWeight.bold, color: strongForegroundColor),
      ),
      ConfigConstant.sizedBoxH1,
      Text(
        "Register to purchase or restore your add-ons.",
        style: M3TextTheme.of(context).bodyLarge?.copyWith(color: foregroundColor),
      ),
    ];
  }
}

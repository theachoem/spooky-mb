library sign_in_view;

import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/storages/local_storages/nickname_storage.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:spooky/views/authentication/base/base_auth_view_model.dart';

abstract class BaseAuthView extends StatelessWidget {
  const BaseAuthView({Key? key}) : super(key: key);

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
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(""),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        padding: ConfigConstant.layoutPadding.copyWith(top: 200),
        children: [
          Text(
            "Join us now!",
            style: M3TextTheme.of(context).headlineLarge,
          ),
          FutureBuilder<String?>(
            future: NicknameStorage().read(),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? "",
                style: M3TextTheme.of(context).headlineLarge?.copyWith(fontWeight: FontWeight.bold),
              );
            },
          ),
          Text(
            "Welcome back,",
            style: M3TextTheme.of(context).headlineLarge,
          ),
        ],
      ),
    );
  }
}

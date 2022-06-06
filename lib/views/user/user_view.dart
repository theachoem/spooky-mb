library user_view;

import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'user_view_model.dart';

part 'user_mobile.dart';
part 'user_tablet.dart';
part 'user_desktop.dart';

class UserView extends StatelessWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<UserViewModel>(
      create: (context) => UserViewModel(),
      onModelReady: (context, viewModel) {},
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _UserMobile(viewModel),
          desktop: _UserDesktop(viewModel),
          tablet: _UserTablet(viewModel),
        );
      },
    );
  }
}

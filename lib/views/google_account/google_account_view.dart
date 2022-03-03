library google_account_view;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/home/local_widgets/story_tile.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'google_account_view_model.dart';

part 'google_account_mobile.dart';
part 'google_account_tablet.dart';
part 'google_account_desktop.dart';

class GoogleAccountView extends StatelessWidget {
  const GoogleAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<GoogleAccountViewModel>(
      create: (conext) => GoogleAccountViewModel(),
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _GoogleAccountMobile(viewModel),
          desktop: _GoogleAccountDesktop(viewModel),
          tablet: _GoogleAccountTablet(viewModel),
        );
      },
    );
  }
}

library user_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart' as router;
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
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
        return ScreenTypeLayout(
          mobile: _UserMobile(viewModel),
          desktop: _UserDesktop(viewModel),
          tablet: _UserTablet(viewModel),
        );
      },
    );
  }
}

library user_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/authentication/base/auth_provider_datas.dart';
import 'package:spooky/views/user/local_widgets/user_image_profile.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'user_view_model.dart';

part 'user_mobile.dart';

class UserView extends StatelessWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<UserViewModel>(
      create: (context) => UserViewModel(),
      onModelReady: (context, viewModel) {},
      builder: (context, viewModel, child) {
        return _UserMobile(viewModel);
      },
    );
  }
}

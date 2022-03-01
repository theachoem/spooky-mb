library nickname_creator_view;

import 'package:provider/provider.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/routes/sp_route_config.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/utils/constants/config_constant.dart';

import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'nickname_creator_view_model.dart';

part 'nickname_creator_mobile.dart';
part 'nickname_creator_tablet.dart';
part 'nickname_creator_desktop.dart';

class NicknameCreatorView extends StatelessWidget {
  const NicknameCreatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (BuildContext context) => NicknameCreatorViewModel(),
      builder: (context, child) {
        NicknameCreatorViewModel model = Provider.of<NicknameCreatorViewModel>(context);
        return SpScreenTypeLayout(
          mobile: _NicknameCreatorMobile(model),
          desktop: _NicknameCreatorDesktop(model),
          tablet: _NicknameCreatorTablet(model),
        );
      },
    );
  }
}

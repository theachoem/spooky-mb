library nickname_creator_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/route/sp_route_config.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/widgets/sp_button.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:stacked/stacked.dart';
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
    return ViewModelBuilder<NicknameCreatorViewModel>.reactive(
      viewModelBuilder: () => NicknameCreatorViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _NicknameCreatorMobile(model),
          desktop: _NicknameCreatorDesktop(model),
          tablet: _NicknameCreatorTablet(model),
        );
      },
    );
  }
}

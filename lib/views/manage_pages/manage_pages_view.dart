library manage_pages_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_dimissable_background.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'manage_pages_view_model.dart';

part 'manage_pages_mobile.dart';
part 'manage_pages_tablet.dart';
part 'manage_pages_desktop.dart';

class ManagePagesView extends StatelessWidget {
  const ManagePagesView({
    Key? key,
    required this.content,
  }) : super(key: key);

  final StoryContentDbModel content;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ManagePagesViewModel>(
      create: (BuildContext context) => ManagePagesViewModel(content),
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _ManagePagesMobile(viewModel),
          desktop: _ManagePagesDesktop(viewModel),
          tablet: _ManagePagesTablet(viewModel),
        );
      },
    );
  }
}

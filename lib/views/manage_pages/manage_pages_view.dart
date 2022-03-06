library manage_pages_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/story_content_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_dimissable_background.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
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

  final StoryContentModel content;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ManagePagesViewModel>(
      create: (BuildContext context) => ManagePagesViewModel(content),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _ManagePagesMobile(viewModel),
          desktop: _ManagePagesDesktop(viewModel),
          tablet: _ManagePagesTablet(viewModel),
        );
      },
    );
  }
}
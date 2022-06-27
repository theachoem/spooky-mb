library story_pad_restore_view;

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/bottom_sheet_service.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/views/home/local_widgets/story_list.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_stepper.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'story_pad_restore_view_model.dart';

part 'story_pad_restore_mobile.dart';

class StoryPadRestoreView extends StatelessWidget {
  const StoryPadRestoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StoryPadRestoreViewModel>(
      create: (context) => StoryPadRestoreViewModel(),
      onModelReady: (context, model) {},
      builder: (context, viewModel, child) {
        return _StoryPadRestoreMobile(viewModel);
      },
    );
  }
}

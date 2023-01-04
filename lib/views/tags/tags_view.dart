library tags_view;

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/tag_db_model.dart';
import 'package:spooky/core/models/story_query_options_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/types/path_type.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/views/detail/detail_view.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'tags_view_model.dart';

part '../tags/tags_mobile.dart';

class TagsView extends StatelessWidget {
  const TagsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<TagsViewModel>(
      create: (BuildContext context) => TagsViewModel(),
      builder: (context, viewModel, child) {
        // prevent ios drag to pop
        return WillPopScope(
          onWillPop: () async => true,
          child: _TagsMobile(viewModel),
        );
      },
    );
  }
}

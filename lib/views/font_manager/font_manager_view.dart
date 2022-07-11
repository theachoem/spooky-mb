library font_manager_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/utils/mixins/scaffold_toggle_sheetable_mixin.dart';
import 'package:spooky/views/font_manager/local_widgets/font_list.dart';
import 'package:spooky/views/font_manager/local_widgets/font_manager_search_delegate.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'font_manager_view_model.dart';

part 'font_manager_mobile.dart';

class FontManagerView extends StatelessWidget {
  const FontManagerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<FontManagerViewModel>(
      create: (_) => FontManagerViewModel(),
      builder: (context, viewModel, child) {
        return _FontManagerMobile(viewModel);
      },
    );
  }
}

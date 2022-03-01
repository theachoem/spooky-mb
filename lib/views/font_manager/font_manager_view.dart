library font_manager_view;

import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'font_manager_view_model.dart';

part 'font_manager_mobile.dart';
part 'font_manager_tablet.dart';
part 'font_manager_desktop.dart';

class FontManagerView extends StatelessWidget {
  const FontManagerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<FontManagerViewModel>(
      create: (_) => FontManagerViewModel(),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _FontManagerMobile(viewModel),
          desktop: _FontManagerDesktop(viewModel),
          tablet: _FontManagerTablet(viewModel),
        );
      },
    );
  }
}

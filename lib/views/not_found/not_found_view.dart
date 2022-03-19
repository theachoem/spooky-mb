library not_found_view;

import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'not_found_view_model.dart';

part 'not_found_mobile.dart';
part 'not_found_tablet.dart';
part 'not_found_desktop.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<NotFoundViewModel>(
      create: (_) => NotFoundViewModel(),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _NotFoundMobile(viewModel),
          desktop: _NotFoundDesktop(viewModel),
          tablet: _NotFoundTablet(viewModel),
        );
      },
    );
  }
}

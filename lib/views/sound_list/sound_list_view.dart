library sound_list_view;

import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'sound_list_view_model.dart';

part 'sound_list_mobile.dart';
part 'sound_list_tablet.dart';
part 'sound_list_desktop.dart';

class SoundListView extends StatelessWidget {
  const SoundListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SoundListViewModel>(
      create: (context) => SoundListViewModel(),
      builder: (context, viewModel, child) {
        return SpScreenTypeLayout(
          mobile: _SoundListMobile(viewModel),
          desktop: _SoundListDesktop(viewModel),
          tablet: _SoundListTablet(viewModel),
        );
      },
    );
  }
}

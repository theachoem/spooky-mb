library sound_list_view;

import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
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

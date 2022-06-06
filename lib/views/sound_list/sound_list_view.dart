library sound_list_view;

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/bottom_nav_item_list_model.dart';
import 'package:spooky/core/models/bottom_nav_item_model.dart';
import 'package:spooky/core/models/sound_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/product_as_type.dart';
import 'package:spooky/core/types/sound_type.dart';
import 'package:spooky/providers/bottom_nav_items_provider.dart';
import 'package:spooky/providers/in_app_purchase_provider.dart';
import 'package:spooky/providers/mini_sound_player_provider.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_fade_in.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'sound_list_view_model.dart';

part 'sound_list_mobile.dart';
part 'sound_list_tablet.dart';
part 'sound_list_desktop.dart';
part 'local_widgets/sound_tile.dart';
part 'local_widgets/sound_type_header.dart';

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

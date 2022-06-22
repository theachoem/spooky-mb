library nickname_creator_view;

import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/providers/nickname_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:flutter/material.dart';
import 'package:spooky/widgets/sp_single_button_bottom_navigation.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'nickname_creator_view_model.dart';

part 'nickname_creator_adaptive.dart';

class NicknameCreatorView extends StatelessWidget {
  const NicknameCreatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<NicknameCreatorViewModel>(
      create: (BuildContext context) => NicknameCreatorViewModel(),
      builder: (context, viewModel, child) {
        return _NicknameCreatorAdaptive(viewModel);
      },
    );
  }
}

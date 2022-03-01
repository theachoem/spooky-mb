library security_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:provider/provider.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/types/lock_type.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';

import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'security_view_model.dart';

part 'security_mobile.dart';
part 'security_tablet.dart';
part 'security_desktop.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (BuildContext context) => SecurityViewModel(),
      builder: (context, child) {
        SecurityViewModel model = Provider.of<SecurityViewModel>(context);
        return SpScreenTypeLayout(
          mobile: _SecurityMobile(model),
          desktop: _SecurityDesktop(model),
          tablet: _SecurityTablet(model),
        );
      },
    );
  }
}

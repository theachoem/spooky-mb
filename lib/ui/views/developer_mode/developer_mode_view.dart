library developer_mode_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:restart_app/restart_app.dart';
import 'package:spooky/app.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/ui/widgets/sp_screen_type_layout.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'developer_mode_view_model.dart';

part 'developer_mode_mobile.dart';
part 'developer_mode_tablet.dart';
part 'developer_mode_desktop.dart';

class DeveloperModeView extends StatelessWidget {
  const DeveloperModeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeveloperModeViewModel>.reactive(
      viewModelBuilder: () => DeveloperModeViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return SpScreenTypeLayout(
          mobile: _DeveloperModeMobile(model),
          desktop: _DeveloperModeDesktop(model),
          tablet: _DeveloperModeTablet(model),
        );
      },
    );
  }
}

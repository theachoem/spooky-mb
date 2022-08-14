library developer_mode_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/providers/nickname_provider.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'developer_mode_view_model.dart';

part 'developer_mode_mobile.dart';

class DeveloperModeView extends StatelessWidget {
  const DeveloperModeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DeveloperModeViewModel>(
      create: (BuildContext context) => DeveloperModeViewModel(),
      builder: (context, viewModel, child) {
        return _DeveloperModeMobile(viewModel);
      },
    );
  }
}

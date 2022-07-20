library account_deletion_view;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/providers/nickname_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_stepper.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'account_deletion_view_model.dart';

part 'account_deletion_mobile.dart';

class AccountDeletionView extends StatelessWidget {
  const AccountDeletionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AccountDeletionViewModel>(
      create: (_) => AccountDeletionViewModel(),
      onModelReady: (context, viewModel) {},
      builder: (context, viewModel, child) {
        return _AccountDeletionMobile(viewModel);
      },
    );
  }
}

library security_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/security/helpers/security_question_list_model.dart';
import 'package:spooky/core/security/helpers/security_question_model.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/lock_type.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/mixins/scaffold_end_drawerable_mixin.dart';
import 'package:spooky/widgets/sp_app_bar_title.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:flutter/material.dart';
import 'security_view_model.dart';

part 'security_mobile.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SecurityViewModel>(
      create: (BuildContext context) => SecurityViewModel(),
      builder: (context, viewModel, child) {
        return _SecurityMobile(viewModel);
      },
    );
  }
}

library add_ons_view;

import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/models/product_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/product_as_type.dart';
import 'package:spooky/providers/in_app_purchase_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/views/setting/local_widgets/user_icon_button.dart';
import 'package:spooky/widgets/sp_add_on_visibility.dart';
import 'package:spooky/widgets/sp_cross_fade.dart';
import 'package:spooky/widgets/sp_developer_visibility.dart';
import 'package:spooky/widgets/sp_expanded_app_bar.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_single_button_bottom_navigation.dart';
import 'package:spooky/widgets/sp_tap_effect.dart';
import 'package:spooky/views/add_ons/add_ons_view_model.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

part 'add_ons_mobile.dart';

class AddOnsView extends StatelessWidget {
  const AddOnsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AddOnsViewModel>(
      create: (_) => AddOnsViewModel(context),
      onModelReady: (context, provider) {
        context.read<InAppPurchaseProvider>().fetchProducts();
        context.read<InAppPurchaseProvider>().loadPurchasedProducts();
      },
      builder: (context, viewModel, child) {
        return _AddOnsMobile(viewModel);
      },
    );
  }
}

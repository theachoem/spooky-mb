library detail_view;

import 'package:flutter_quill/flutter_quill.dart' as editor;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/views/detail/local_widgets/detail_scaffold.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';
import 'package:spooky/ui/widgets/sp_pop_button.dart';
import 'package:spooky/ui/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'detail_view_model.dart';

part 'detail_mobile.dart';
part 'detail_tablet.dart';
part 'detail_desktop.dart';

class DetailView extends StatelessWidget {
  const DetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailViewModel>.reactive(
      viewModelBuilder: () => DetailViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return ScreenTypeLayout(
          mobile: _DetailMobile(model),
          desktop: _DetailDesktop(model),
          tablet: _DetailTablet(model),
        );
      },
    );
  }
}

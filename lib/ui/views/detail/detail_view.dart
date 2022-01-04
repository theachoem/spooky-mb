library detail_view;

import 'package:responsive_builder/responsive_builder.dart';
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

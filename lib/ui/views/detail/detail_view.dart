library detail_view;

import 'package:flutter_quill/flutter_quill.dart' as editor;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/views/detail/local_widgets/detail_scaffold.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'detail_view_model.dart';

part 'detail_mobile.dart';
part 'detail_tablet.dart';
part 'detail_desktop.dart';

class DetailView extends StatelessWidget {
  const DetailView({
    Key? key,
    this.story,
  }) : super(key: key);

  final StoryModel? story;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailViewModel>.reactive(
      viewModelBuilder: () => DetailViewModel(story),
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

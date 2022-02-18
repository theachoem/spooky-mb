library detail_view;

import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/views/detail/local_widgets/detail_editor.dart';
import 'package:spooky/ui/views/detail/local_widgets/detail_scaffold.dart';
import 'package:spooky/ui/views/detail/local_widgets/detail_toolbar.dart';
import 'package:spooky/ui/widgets/sp_page_view/sp_page_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'detail_view_model.dart';

part 'detail_mobile.dart';
part 'detail_tablet.dart';
part 'detail_desktop.dart';

class DetailView extends StatelessWidget {
  const DetailView({
    Key? key,
    required this.initialStory,
    required this.intialFlow,
  }) : super(key: key);

  final StoryModel initialStory;
  final DetailViewFlow intialFlow;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailViewModel>.reactive(
      viewModelBuilder: () => DetailViewModel(initialStory, intialFlow),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () => onWillPop(model, context),
          child: ScreenTypeLayout(
            mobile: _DetailMobile(model),
            desktop: _DetailDesktop(model),
            tablet: _DetailTablet(model),
          ),
        );
      },
    );
  }

  Future<bool> onWillPop(DetailViewModel model, BuildContext context) async {
    if (model.hasChange) await model.save(context);
    Navigator.of(context).pop(model.currentStory);
    return true;
  }
}

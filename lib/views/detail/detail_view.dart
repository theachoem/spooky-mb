library detail_view;

import 'package:provider/provider.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/views/detail/local_widgets/detail_editor.dart';
import 'package:spooky/views/detail/local_widgets/detail_scaffold.dart';
import 'package:spooky/views/detail/local_widgets/detail_toolbar.dart';
import 'package:spooky/widgets/sp_page_view/sp_page_view.dart';
import 'package:spooky/widgets/sp_screen_type_layout.dart';

import 'package:flutter/material.dart';
import 'package:spooky/views/detail/detail_view_model.dart';

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
  final DetailViewFlowType intialFlow;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (BuildContext context) => DetailViewModel(currentStory: initialStory, flowType: intialFlow),
      builder: (context, child) {
        DetailViewModel model = Provider.of<DetailViewModel>(context);
        return WillPopScope(
          onWillPop: () => onWillPop(model, context),
          child: SpScreenTypeLayout(
            mobile: _DetailMobile(model),
            desktop: _DetailDesktop(model),
            tablet: _DetailTablet(model),
          ),
        );
      },
    );
  }

  Future<bool> onWillPop(DetailViewModel model, BuildContext context) async {
    if (model.hasChange) await model.save();
    Navigator.of(context).pop(model.currentStory);
    return true;
  }
}

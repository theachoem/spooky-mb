library detail_view;

import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/views/detail/local_widgets/detail_editor.dart';
import 'package:spooky/views/detail/local_widgets/detail_scaffold.dart';
import 'package:spooky/views/detail/local_widgets/detail_toolbar.dart';
import 'package:spooky/widgets/sp_page_view/sp_page_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
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

  final StoryDbModel initialStory;
  final DetailViewFlowType intialFlow;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DetailViewModel>(
      create: (BuildContext context) => DetailViewModel(currentStory: initialStory, flowType: intialFlow),
      builder: (context, viewModel, child) {
        return WillPopScope(
          onWillPop: () => onWillPop(viewModel, context),
          child: ScreenTypeLayout(
            mobile: _DetailMobile(viewModel),
            desktop: _DetailDesktop(viewModel),
            tablet: _DetailTablet(viewModel),
          ),
        );
      },
    );
  }

  Future<bool> onWillPop(DetailViewModel model, BuildContext context) async {
    if (model.hasChange) await model.save();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop(model.currentStory);
    return true;
  }
}

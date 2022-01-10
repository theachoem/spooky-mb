library detail_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:spooky/core/route/router.dart' as route;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spooky/core/models/story_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/views/detail/local_widgets/detail_editor.dart';
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
    required this.story,
  }) : super(key: key);

  // if(story?.documentId != null)
  //      flowType = DetailViewFlow.update
  // else flowType = DetailViewFlow.create;
  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    if (story.flowType == DetailViewFlow.create) assert(story.pathDate != null);
    return ViewModelBuilder<DetailViewModel>.reactive(
      viewModelBuilder: () => DetailViewModel(story),
      onModelReady: (model) {},
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (model.hasChange) {
              OkCancelResult result = await showOkCancelAlertDialog(
                context: context,
                title: "Do you want to save changes?",
                isDestructiveAction: false,
                barrierDismissible: true,
              );
              switch (result) {
                case OkCancelResult.ok:
                  await model.save(context);
                  context.router.popForced(model.currentStory);
                  return true;
                case OkCancelResult.cancel:
                  return false;
              }
            }
            context.router.popForced(model.currentStory);
            return true;
          },
          child: ScreenTypeLayout(
            mobile: _DetailMobile(model),
            desktop: _DetailDesktop(model),
            tablet: _DetailTablet(model),
          ),
        );
      },
    );
  }
}

library detail_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/views/detail/local_widgets/detail_editor.dart';
import 'package:spooky/views/detail/local_widgets/detail_scaffold.dart';
import 'package:spooky/views/detail/local_widgets/detail_toolbar.dart';
import 'package:spooky/views/detail/local_widgets/editor_wrapper.dart';
import 'package:spooky/widgets/sp_page_view/sp_page_view.dart';
import 'package:flutter/material.dart';
import 'package:spooky/views/detail/detail_view_model.dart';

part 'detail_mobile.dart';

class DetailView extends StatelessWidget {
  static const String appBarHeroKey = "DetailViewAppBar";

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
        return ValueListenableBuilder<bool>(
          valueListenable: viewModel.hasChangeNotifer,
          child: _DetailMobile(viewModel),
          builder: (context, hasChange, child) {
            return WillPopScope(
              onWillPop: () => onWillPop(viewModel, context),
              child: child!,
            );
          },
        );
      },
    );
  }

  Future<bool> onWillPop(DetailViewModel model, BuildContext context) async {
    if (model.hasChangeNotifer.value) {
      final action = await showModalActionSheet(
        context: context,
        title: tr("alert.save_draft"),
        actions: [
          SheetAction(
            label: tr("button.save_exit"),
            icon: Icons.save,
            key: 'save',
          ),
          SheetAction(
            label: tr("button.discard"),
            isDestructiveAction: true,
            icon: Icons.cancel_rounded,
            key: 'discard',
          ),
        ],
      );

      if (action == "save") {
        // ignore: use_build_context_synchronously
        await model.save(context);
        return true;
      } else if (action == "discard") {
        return showOkCancelAlertDialog(
          context: context,
          title: tr("alert.discard_draft.title"),
          message: tr("alert.discard_draft.message"),
          isDestructiveAction: true,
          okLabel: tr("button.discard"),
        ).then((value) {
          return value == OkCancelResult.ok;
        });
      }

      return false;
    } else {
      return true;
    }
  }
}

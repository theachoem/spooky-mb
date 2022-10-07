library detail_view;

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/providers/theme_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/views/detail/black_out_notifier.dart';
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
    return ViewModelProvider<BlackOutNotifier>(
      create: (BuildContext context) => BlackOutNotifier(),
      builder: (context, notifier, child) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final ThemeProvider data = context.read<ThemeProvider>();

        final blackoutTheme = data.darkTheme.copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: data.darkTheme.appBarTheme.copyWith(backgroundColor: Colors.black),
          colorScheme: data.darkTheme.colorScheme.copyWith(
            background: Colors.black,
            surface: Colors.black,
          ),
        );

        return Theme(
          data: notifier.blackout
              ? blackoutTheme
              : isDarkMode
                  ? data.darkTheme
                  : data.lightTheme,
          child: buildView(),
        );
      },
    );
  }

  Widget buildView() {
    return ViewModelProvider<DetailViewModel>(
      create: (BuildContext context) => DetailViewModel(currentStory: initialStory, flowType: intialFlow),
      builder: (context, viewModel, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: viewModel.hasChangeNotifer,
          child: _DetailMobile(viewModel),
          builder: (context, hasChange, child) {
            return WillPopScope(
              onWillPop: hasChange ? () => onWillPop(viewModel, context) : null,
              child: child!,
            );
          },
        );
      },
    );
  }

  Future<bool> onWillPop(DetailViewModel model, BuildContext context) async {
    final action = await showModalActionSheet(
      context: context,
      title: tr("alert.save_draft"),
      cancelLabel: tr("button.cancel"),
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
        cancelLabel: tr("button.cancel"),
      ).then((value) {
        return value == OkCancelResult.ok;
      });
    }

    return false;
  }
}

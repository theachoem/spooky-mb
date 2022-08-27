import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
import 'package:spooky/views/detail/black_out_notifier.dart';
import 'package:spooky/views/detail/detail_view_model.dart';
import 'package:spooky/widgets/sp_button.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';

class DetailSheet extends StatelessWidget {
  const DetailSheet({
    Key? key,
    required this.viewModel,
    required this.toggleSpBottomSheet,
    required this.isSpBottomSheetOpenNotifer,
    required this.readOnlyNotifier,
  }) : super(key: key);

  final DetailViewModel viewModel;
  final void Function() toggleSpBottomSheet;
  final ValueNotifier<bool> isSpBottomSheetOpenNotifer;
  final ValueNotifier<bool> readOnlyNotifier;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ScrollPhysics(),
      children: SpSectionsTiles.divide(
        context: context,
        sections: [
          SpSectionContents(
            headline: tr("section.title"),
            tiles: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
                child: ValueListenableBuilder<bool>(
                  valueListenable: readOnlyNotifier,
                  builder: (context, readOnly, child) {
                    return TextField(
                      maxLines: null,
                      readOnly: readOnly,
                      controller: viewModel.titleController,
                      decoration: const InputDecoration(
                        hintText: "...",
                        border: InputBorder.none,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // COMMENT AS IT MOVED TO OUTSIDE.
          // ALSO NOT PERFECTLY WORK YET.
          // buildDateTilesSection(context),

          // buildActionsSection(context),
          buildSettingSection(context),
        ],
      )..addAll(buildExtraSections(context)),
    );
  }

  List<Widget> buildExtraSections(BuildContext context) {
    return [
      ConfigConstant.sizedBoxH1,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListTile(
          title: Text(tr("tile.blackout.title")),
          leading: const Icon(Icons.dark_mode),
          trailing: Switch.adaptive(
            value: context.read<BlackOutNotifier>().blackout,
            onChanged: (value) => context.read<BlackOutNotifier>().toggle(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: ConfigConstant.circlarRadius2,
            side: BorderSide(
              color: Theme.of(context).dividerColor,
            ),
          ),
          onTap: () {
            context.read<BlackOutNotifier>().toggle();
          },
        ),
      ),
    ];
  }

  // SpSectionContents buildDateTilesSection(BuildContext context) {
  //   return SpSectionContents(
  //     headline: null,
  //     tiles: [
  //       StoryDateTile(viewModel: viewModel),
  //       StoryTimeTile(viewModel: viewModel),
  //     ],
  //   );
  // }

  SpSectionContents buildSettingSection(BuildContext context) {
    bool showChanges = false;
    if (viewModel.currentStory.rawChanges?.isNotEmpty == true) showChanges = true;
    if (viewModel.currentStory.changes.isNotEmpty == true) showChanges = true;

    return SpSectionContents(
      headline: tr("section.settings"),
      tiles: [
        ListTile(
          title: Text(SpRouter.fontManager.datas.title),
          leading: const Icon(Icons.font_download),
          onTap: () {
            Navigator.of(context).pushNamed(SpRouter.fontManager.path);
          },
        ),
        if ((viewModel.currentContent.pages ?? []).length > 1) buildPagesTile(context),
        if (showChanges) buildChangesTile(context),
      ],
    );
  }

  ListTile buildChangesTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(tr("tile.changes.title")),
      onTap: () async {
        viewModel.beforeAction(() {
          return viewChanges(context);
        });
        // if (isSpBottomSheetOpenNotifer.value) toggleSpBottomSheet();
      },
    );
  }

  ListTile buildPagesTile(BuildContext context) {
    return ListTile(
      leading: const Icon(CommunityMaterialIcons.book_settings),
      title: Text(tr("tile.pages.title")),
      onTap: () {
        viewModel.beforeAction(() {
          return viewPages(context);
        });
      },
    );
  }

  SpSectionContents buildActionsSection(BuildContext context) {
    return SpSectionContents(
      headline: tr("section.actions"),
      tiles: [
        if (viewModel.flowType == DetailViewFlowType.update && viewModel.currentStory.archivable)
          Container(
            margin: const EdgeInsets.only(left: ConfigConstant.margin2, top: ConfigConstant.margin0),
            child: SpButton(
              label: tr("button.archive"),
              onTap: () async {
                viewModel.beforeAction(() {
                  return onArchive(context);
                });
              },
            ),
          ),
      ],
    );
  }

  Future<void> onArchive(BuildContext context) async {
    final StoryDatabase database = StoryDatabase.instance;

    if (viewModel.hasChangeNotifer.value) {
      MessengerService.instance.showSnackBar(tr("alert.save_document_first.title"));
      return;
    }

    OkCancelResult result = await showOkCancelAlertDialog(
      context: context,
      useRootNavigator: true,
      title: tr("alert.are_you_sure_to_archive.title"),
      okLabel: tr("button.ok"),
      cancelLabel: tr("button.cancel"),
    );
    switch (result) {
      case OkCancelResult.ok:
        await database.archiveDocument(viewModel.currentStory).then((story) async {
          if (story != null) {
            MessengerService.instance.showSnackBar(tr("msg.archived"));
          }
          Navigator.of(context).maybePop(viewModel.currentStory);
        });
        break;
      case OkCancelResult.cancel:
        break;
    }
  }

  Future<void> viewPages(BuildContext context) async {
    if (viewModel.hasChangeNotifer.value) {
      MessengerService.instance.showSnackBar(tr("alert.save_document_first.title"));
      return;
    }

    ManagePagesArgs arguments = ManagePagesArgs(content: viewModel.currentContent);
    Navigator.of(context).pushNamed(SpRouter.managePages.path, arguments: arguments).then((value) {
      if (value is StoryContentDbModel) {
        MessengerService.instance.showLoading(
          future: () => viewModel.updatePages(value).then((value) => 1),
          context: App.navigatorKey.currentContext!,
          debugSource: "DetailSheet",
        );
      }
    });

    // if (isSpBottomSheetOpenNotifer.value) toggleSpBottomSheet();
  }

  Future<void> viewChanges(BuildContext context) async {
    if (viewModel.hasChangeNotifer.value) {
      MessengerService.instance.showSnackBar(tr("alert.save_document_first.title"));
      return;
    }

    ChangesHistoryArgs arguments = ChangesHistoryArgs(
      story: viewModel.currentStory,
      onRestorePressed: (contentId, storyFromChangesView) {
        MessengerService.instance.showLoading(
          future: () => viewModel.restore(contentId, storyFromChangesView).then((value) => 1),
          context: App.navigatorKey.currentContext!,
          debugSource: "DetailSheet",
        );
      },
      onDeletePressed: (contentIds, storyFromChangesView) async {
        return await MessengerService.instance.showLoading(
              future: () => viewModel.deleteChange(contentIds, storyFromChangesView),
              context: App.navigatorKey.currentContext!,
              debugSource: "DetailSheet",
            ) ??
            viewModel.currentStory;
      },
    );

    await Navigator.of(context).pushNamed(
      SpRouter.changesHistory.path,
      arguments: arguments,
    );
  }
}

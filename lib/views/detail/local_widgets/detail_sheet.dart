import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/db/models/story_content_db_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/detail_view_flow_type.dart';
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
        showTopDivider: true,
        sections: [
          SpSectionContents(
            headline: "Title",
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
      ),
    );
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
    return SpSectionContents(
      headline: "Options",
      tiles: [
        // if ((widget.viewModel.currentContent.pages ?? []).length > 1)
        ListTile(
          leading: const Icon(CommunityMaterialIcons.book_settings),
          title: const Text("Pages"),
          onTap: () {
            if (viewModel.hasChangeNotifer.value) {
              MessengerService.instance.showSnackBar("Please save document first");
              return;
            }
            ManagePagesArgs arguments = ManagePagesArgs(content: viewModel.currentContent);
            Navigator.of(context).pushNamed(SpRouter.managePages.path, arguments: arguments).then((value) {
              if (value is StoryContentDbModel) viewModel.updatePages(value);
            });

            if (isSpBottomSheetOpenNotifer.value) toggleSpBottomSheet();
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text("Changes"),
          onTap: () async {
            if (viewModel.hasChangeNotifer.value) {
              MessengerService.instance.showSnackBar("Please save document first");
              return;
            }

            ChangesHistoryArgs arguments = ChangesHistoryArgs(
              story: viewModel.currentStory,
              onRestorePressed: (content) => viewModel.restore(content.id),
              onDeletePressed: (contentIds) => viewModel.deleteChange(contentIds),
            );

            Navigator.of(context).pushNamed(
              SpRouter.changesHistory.path,
              arguments: arguments,
            );

            if (isSpBottomSheetOpenNotifer.value) toggleSpBottomSheet();
          },
        ),
        ListTile(
          title: Text(SpRouter.fontManager.title),
          leading: const Icon(Icons.font_download),
          onTap: () {
            Navigator.of(context).pushNamed(SpRouter.fontManager.path);
          },
        ),
      ],
    );
  }

  SpSectionContents buildActionsSection(BuildContext context) {
    return SpSectionContents(
      headline: "Actions",
      tiles: [
        if (viewModel.flowType == DetailViewFlowType.update && viewModel.currentStory.archivable)
          Container(
            margin: const EdgeInsets.only(left: ConfigConstant.margin2, top: ConfigConstant.margin0),
            child: SpButton(
              label: "Archive",
              onTap: () async {
                final StoryDatabase database = StoryDatabase.instance;

                if (viewModel.hasChangeNotifer.value) {
                  MessengerService.instance.showSnackBar("Please save document first");
                  return;
                }
                OkCancelResult result = await showOkCancelAlertDialog(
                  context: context,
                  useRootNavigator: true,
                  title: "Are you sure to archive document?",
                );
                switch (result) {
                  case OkCancelResult.ok:
                    await database.archiveDocument(viewModel.currentStory).then((story) async {
                      if (story != null) {
                        MessengerService.instance.showSnackBar("Archived!");
                      }
                      Navigator.of(context).maybePop(viewModel.currentStory);
                    });
                    break;
                  case OkCancelResult.cancel:
                    break;
                }
              },
            ),
          ),
      ],
    );
  }
}

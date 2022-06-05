import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/models/backup_display_model.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/services/bottom_sheet_service.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/views/home/local_widgets/story_list.dart';
import 'package:spooky/views/restore/restore_view_model.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';
import 'package:spooky/widgets/sp_small_chip.dart';

class BackupHistories extends StatefulWidget {
  const BackupHistories({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.items,
    required this.viewModel,
    required this.initialSelectedId,
  }) : super(key: key);

  final RestoreViewModel viewModel;
  final List<CloudFileModel> items;
  final ScrollController controller;
  final void Function(CloudFileModel selected) onChanged;
  final String? initialSelectedId;

  @override
  State<BackupHistories> createState() => _BackupHistoriesState();
}

class _BackupHistoriesState extends State<BackupHistories> {
  late List<BackupDisplayModel> displayModels;
  late String? selectedId;

  @override
  void initState() {
    selectedId = widget.initialSelectedId;
    displayModels = widget.items.map((e) => BackupDisplayModel.fromCloudModel(e)).toList();
    displayModels.sort((a, b) => (a.createAt != null ? b.createAt?.compareTo(a.createAt!) : -1) ?? -1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      itemCount: displayModels.length,
      itemBuilder: (_, index) {
        CloudFileModel backup = widget.items[index];
        BackupDisplayModel display = displayModels[index];
        return SpPopupMenuButton(
          dxGetter: (dx) => MediaQuery.of(context).size.width,
          items: (context) => buildChildItems(
            context: context,
            cloudBackup: backup,
            displayBackup: display,
            items: widget.items,
            displayModels: displayModels,
            canDelete: index != 0,
          ),
          builder: (callback) {
            String title = backup.id.hashCode.toString();
            return Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    groupValue: selectedId,
                    value: backup.id,
                    onChanged: (value) {
                      setState(() {
                        selectedId = value ?? widget.initialSelectedId;
                        widget.onChanged(backup);
                      });
                    },
                    title: RichText(
                      text: TextSpan(
                        text: "$title ",
                        style: M3TextTheme.of(context).titleMedium,
                        children: [
                          if (index == 0)
                            const WidgetSpan(
                              child: SpSmallChip(label: "Latest"),
                              alignment: PlaceholderAlignment.middle,
                            ),
                        ],
                      ),
                    ),
                    subtitle: Text("Synced at ${display.displayDateTime}"),
                  ),
                ),
                SpIconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: callback,
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<SpPopMenuItem> buildChildItems({
    required BuildContext context,
    required CloudFileModel cloudBackup,
    required BackupDisplayModel displayBackup,
    required List<CloudFileModel> items,
    required List<BackupDisplayModel> displayModels,
    required bool canDelete,
  }) {
    return [
      if (canDelete)
        SpPopMenuItem(
          title: "Delete",
          leadingIconData: Icons.delete,
          titleStyle: TextStyle(color: M3Color.of(context).error),
          onPressed: () async {
            await widget.viewModel.delete(context, cloudBackup).then((value) {
              Navigator.of(context).pop();
            });
          },
        ),
      SpPopMenuItem(
        leadingIconData: widget.viewModel.getCache(cloudBackup) == null ? Icons.download : Icons.list,
        title: widget.viewModel.getCache(cloudBackup) == null ? "Download & View" : "View",
        onPressed: () async {
          BackupModel? result = await MessengerService.instance
              .showLoading(future: () => widget.viewModel.download(cloudBackup), context: context);
          if (result == null) return;
          BottomSheetService.instance.showScrollableSheet(
            context: App.navigatorKey.currentContext ?? context,
            title: displayBackup.createAt?.year.toString() ?? "Stories",
            builder: (context, controller) {
              return StoryList(
                viewOnly: true,
                controller: controller,
                onRefresh: () async {},
                stories: result.stories,
                overridedLayout: ListLayoutType.single,
              );
            },
          );
        },
      ),
    ];
  }
}

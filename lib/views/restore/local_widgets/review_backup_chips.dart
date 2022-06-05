import 'package:flutter/material.dart';
import 'package:spooky/app.dart';
import 'package:spooky/core/models/backup_model.dart';
import 'package:spooky/core/services/bottom_sheet_service.dart';
import 'package:spooky/core/types/list_layout_type.dart';
import 'package:spooky/views/home/local_widgets/story_list.dart';
import 'package:spooky/widgets/sp_chip.dart';

class ReviewBackupChips extends StatelessWidget {
  const ReviewBackupChips({
    Key? key,
    required this.downloadedByYear,
  }) : super(key: key);

  final Map<String, BackupModel> downloadedByYear;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: List.generate(
        downloadedByYear.length,
        (index) {
          final e = downloadedByYear.entries.toList()[index];
          return Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: SpChip(
              labelText: e.key,
              onTap: () async {
                BottomSheetService.instance.showScrollableSheet(
                  context: App.navigatorKey.currentContext ?? context,
                  title: "${e.key} 📌",
                  subtitle: "Backup ID - ${e.value.id.hashCode.toString()}",
                  builder: (context, controller) {
                    return StoryList(
                      viewOnly: true,
                      controller: controller,
                      onRefresh: () async {},
                      stories: e.value.stories,
                      overridedLayout: ListLayoutType.single,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/core/services/bottom_sheet_service.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/views/restore/local_widgets/backup_histories.dart';
import 'package:spooky/views/restore/restore_view_model.dart';
import 'package:spooky/widgets/sp_chip.dart';
import 'package:spooky/widgets/sp_single_button_bottom_navigation.dart';

class BackupChips extends StatelessWidget {
  const BackupChips({
    Key? key,
    required this.viewModel,
    required this.context,
  }) : super(key: key);

  final BuildContext context;
  final RestoreViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final groupByYear = viewModel.groupByYear?.entries.toList() ?? [];
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: List.generate(
        groupByYear.length,
        (index) {
          final e = groupByYear[index];
          return Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: buildEachChip(e),
          );
        },
      ),
    );
  }

  SpChip buildEachChip(MapEntry<String, List<CloudFileModel>> e) {
    return SpChip(
      labelText: e.key,
      onTap: () => viewHistory(e.key, e.value),
    );
  }

  void viewHistory(String year, List<CloudFileModel> items) {
    if (items.isEmpty) {
      MessengerService.instance.showSnackBar("Empty");
      return;
    }

    // CloudFileModel cloudBackup = items.first;
    // BackupDisplayModel displayBackup = displayModels.first;

    BottomSheetService.instance.showScrollableSheet(
      context: context,
      title: year,
      subtitle: "Choose one for download & restore",
      bottomNavigationBarBuilder: (context) => SpSingleButtonBottomNavigation(
        buttonLabel: "Use this version",
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      builder: (BuildContext _, ScrollController controller) {
        return BackupHistories(
          viewModel: viewModel,
          controller: controller,
          items: items,
          initialSelectedId: viewModel.selectedBackupByYear?[year]?.id,
          onChanged: (selected) {
            viewModel.setSelectedBackupByYear(year, selected);
          },
        );
      },
    );
  }
}

import 'package:provider/provider.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/databases/story_database.dart';
import 'package:spooky/core/services/initial_tab_service.dart';
import 'package:spooky/providers/nickname_provider.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';

class HomeViewModel extends BaseViewModel {
  late int year;
  late int month;

  final void Function(int index) onTabChange;
  final void Function(int year) onYearChange;
  final void Function(ScrollController controller) onScrollControllerReady;

  late final ScrollController scrollController;

  HomeViewModel(
    this.onTabChange,
    this.onYearChange,
    this.onScrollControllerReady,
  ) {
    year = InitialStoryTabService.initial.year;
    month = InitialStoryTabService.initial.month;
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onScrollControllerReady(scrollController);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void setYear(int? selectedYear) {
    if (year == selectedYear || selectedYear == null) return;
    year = selectedYear;
    onYearChange(year);
    notifyListeners();
  }

  Future<List<int>> fetchYears() async {
    Set<int> years = await StoryDatabase.instance.fetchYears() ?? {};
    years.add(year);
    return (years.toList()..sort()).reversed.toList();
  }

  int get docsCount {
    return StoryDatabase.instance.getDocsCount(year);
  }

  Future<void> pickYear(BuildContext context) async {
    List<int> years = await fetchYears();

    List<AlertDialogAction<String>> actions = years.map((e) {
      return AlertDialogAction(key: "$e", label: e.toString());
    }).toList()
      ..insert(0, const AlertDialogAction(key: "create", label: "Create new"));

    await showConfirmationDialog(
      context: context,
      title: "Year",
      actions: actions,
      initialSelectedActionKey: "$year",
    ).then((selectedOption) async {
      if (selectedOption == null) return;
      if (selectedOption == "create") {
        DateTime? date = await SpDatePicker.showYearPicker(context);
        if (date != null) {
          int year = date.year;
          setYear(year);
        }
      } else {
        int? year = int.tryParse(selectedOption);
        setYear(year);
      }
    });
  }

  Future<void> openNicknameEditor(BuildContext context) async {
    await showTextInputDialog(
      context: context,
      title: "What should I call you?",
      textFields: [
        DialogTextField(
          initialText: context.read<NicknameProvider>().name,
          keyboardType: TextInputType.name,
        ),
      ],
    ).then((nickname) {
      if (nickname?.isNotEmpty == true) {
        context.read<NicknameProvider>().setNickname(nickname![0]);
      }
    });
  }
}

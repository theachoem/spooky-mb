import 'package:easy_localization/easy_localization.dart';
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

  final void Function(int index) onMonthChange;
  final void Function(int year) onYearChange;
  final void Function(String? tag) onTagChange;
  final void Function(ScrollController controller) onScrollControllerReady;

  late final ScrollController scrollController;
  late final ValueNotifier<int> docsCountNotifier;

  HomeViewModel(
    this.onMonthChange,
    this.onYearChange,
    this.onScrollControllerReady,
    this.onTagChange,
  ) {
    year = InitialStoryTabService.initial.year;
    month = InitialStoryTabService.initial.month;
    scrollController = ScrollController();
    docsCountNotifier = ValueNotifier<int>(0);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      reloadDocsCount();
      onScrollControllerReady(scrollController);
    });
  }

  @override
  void notifyListeners() {
    reloadDocsCount();
    super.notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    docsCountNotifier.dispose();
    super.dispose();
  }

  void reloadDocsCount() {
    docsCountNotifier.value = StoryDatabase.instance.getDocsCount(year);
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

  Future<void> pickYear(BuildContext context) async {
    List<int> years = await fetchYears();

    List<AlertDialogAction<String>> actions = years.map((e) {
      return AlertDialogAction(key: "$e", label: e.toString());
    }).toList()
      ..insert(0, AlertDialogAction(key: "create", label: tr("button.create_new")));

    await showConfirmationDialog(
      context: context,
      title: tr("alert.year.title"),
      actions: actions,
      initialSelectedActionKey: "$year",
      // ignore: use_build_context_synchronously
      cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
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
      title: tr("alert.what_should_I_call_you.title"),
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

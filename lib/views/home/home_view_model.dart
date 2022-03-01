import 'dart:io';
import 'package:provider/provider.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/file_manager/managers/story_manager.dart';
import 'package:spooky/core/services/initial_tab_service.dart';
import 'package:spooky/providers/nickname_provider.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';

class HomeViewModel extends BaseViewModel {
  late int year;
  late int month;

  final StoryManager storyManager = StoryManager();

  final void Function(int index) onTabChange;
  final void Function(int year) onYearChange;

  final void Function(void Function()) onListReloaderReady;
  final void Function(ScrollController controller) onScrollControllerReady;

  late final ScrollController scrollController;

  HomeViewModel(
    this.onTabChange,
    this.onYearChange,
    this.onListReloaderReady,
    this.onScrollControllerReady,
  ) {
    year = InitialStoryTabService.initial.year;
    month = InitialStoryTabService.initial.month;
    scrollController = ScrollController();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
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
    notifyListeners();
    onYearChange(year);
  }

  Future<List<int>> fetchYears() async {
    Directory docsPath = storyManager.directory;
    if (await docsPath.exists()) {
      await storyManager.ensureDirExist(docsPath);

      List<FileSystemEntity> result = docsPath.listSync();
      List<String> years = result.map((e) {
        return e.absolute.path.split("/").last;
      }).toList();

      Set<int> yearsInt = {};
      for (String e in years) {
        int? y = int.tryParse(e);
        if (y != null) yearsInt.add(y);
      }

      yearsInt.add(year);
      return yearsInt.toList();
    }
    return [year];
  }

  int get docsCount {
    Directory docsPath = Directory(storyManager.directory.path + "/" + "$year");
    if (docsPath.existsSync()) {
      List<FileSystemEntity> result = docsPath.listSync(recursive: true);
      return result.where((e) {
        return e is File && e.path.endsWith(AppConstant.documentExstension);
      }).length;
    }
    return 0;
  }

  Future<void> pickYear(BuildContext context) async {
    List<int> years = await fetchYears();

    List<AlertDialogAction<String>> actions = years.map((e) {
      return AlertDialogAction(key: "$e", label: e.toString());
    }).toList()
      ..insert(0, const AlertDialogAction(key: "create", label: "Create new"));

    String? selectedOption = await showConfirmationDialog(
      context: context,
      title: "Year",
      actions: actions,
      initialSelectedActionKey: "$year",
    );

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
  }

  Future<void> openNicknameEditor(BuildContext context) async {
    List<String>? nickname = await showTextInputDialog(
      context: context,
      title: "What should I call you?",
      textFields: [
        DialogTextField(
          initialText: context.read<NicknameProvider>().name,
          keyboardType: TextInputType.name,
        ),
      ],
    );
    if (nickname?.isNotEmpty == true) {
      context.read<NicknameProvider>().setNickname(nickname![0]);
    }
  }
}

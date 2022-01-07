import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:spooky/core/file_manager/docs_manager.dart';

import 'package:spooky/initial_theme.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/ui/views/home/home_view_model.dart';
import 'package:spooky/ui/views/home/local_widgets/home_tab_bar.dart';
import 'package:spooky/ui/widgets/sp_animated_icon.dart';
import 'package:spooky/ui/widgets/sp_icon_button.dart';
import 'package:spooky/ui/widgets/sp_tap_effect.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/utils/extensions/string_extension.dart';
import 'package:spooky/utils/mixins/stateful_mixin.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.tabLabels,
    required this.tabController,
    required this.viewModel,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final List<String> tabLabels;
  final TabController tabController;
  final HomeViewModel viewModel;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> with StatefulMixin {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: appBarTheme.elevation,
      pinned: true,
      floating: true,
      stretch: true,
      expandedHeight: kToolbarHeight + 48.0 + 32.0 + 16.0,
      bottom: HomeTabBar(
        height: 40,
        controller: widget.tabController,
        tabs: List.generate(
          widget.tabLabels.length,
          (index) => widget.tabLabels[index],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: const [
          StretchMode.zoomBackground,
        ],
        background: buildBackground(),
      ),
    );
  }

  Widget buildBackground() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, statusBarHeight + 24.0 + 4.0, 16.0, 0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: textTheme.headline6?.copyWith(color: colorScheme.primary),
              ),
              ConfigConstant.sizedBoxH0,
              SpTapEffect(
                onTap: () async {
                  List<int> years = await widget.viewModel.fetchYears();
                  String? selectedOption = await showConfirmationDialog(
                    context: context,
                    title: "Year",
                    actions: years.map((e) {
                      return AlertDialogAction(
                        key: "$e",
                        label: e.toString(),
                      );
                    }).toList()
                      ..insert(
                        0,
                        AlertDialogAction(
                          key: "create",
                          label: "Create new",
                        ),
                      ),
                  );

                  if (selectedOption == null) return;
                  if (selectedOption == "create") {
                    M3Color color = M3Color.of(context)!;
                    DatePicker.showDatePicker(
                      context,
                      dateFormat: 'yyyy',
                      pickerTheme: DateTimePickerTheme(
                        backgroundColor: color.primary,
                        itemTextStyle: TextStyle(fontFamilyFallback: M3TextTheme.of(context)?.fontFamilyFallback)
                            .copyWith(color: color.onPrimary),
                        cancelTextStyle: TextStyle().copyWith(color: color.onPrimary),
                        confirmTextStyle: TextStyle().copyWith(color: color.onPrimary),
                      ),
                      onConfirm: (DateTime date, List<int> _) {
                        int year = date.year;
                        widget.viewModel.setYear(year);
                      },
                    );
                  } else {
                    int? year = int.tryParse(selectedOption);
                    widget.viewModel.setYear(year);
                  }
                },
                child: Text(
                  widget.subtitle,
                  style: textTheme.bodyText2?.copyWith(color: colorScheme.onSurface),
                ),
              ),
            ],
          ),
          buildThemeSwitcherButton()
        ],
      ),
    );
  }

  Widget buildThemeSwitcherButton() {
    return Positioned(
      right: 0,
      child: SpIconButton(
        icon: getThemeModeIcon(),
        backgroundColor: M3Color.of(context)?.primaryContainer,
        onLongPress: () async {
          ThemeMode? result = await showConfirmationDialog(
            context: context,
            title: "Theme",
            initialSelectedActionKey: InitialTheme.of(context)?.mode,
            actions: themeModeActions,
          );
          if (result != null) {
            InitialTheme.of(context)?.setThemeMode(result);
          }
        },
        onPressed: () {
          InitialTheme.of(context)?.toggleThemeMode();
        },
      ),
    );
  }

  Widget getThemeModeIcon() {
    return SpAnimatedIcons(
      duration: ConfigConstant.duration * 3,
      firstChild: const Icon(Icons.dark_mode, key: ValueKey(Brightness.dark)),
      secondChild: const Icon(Icons.light_mode, key: ValueKey(Brightness.light)),
      showFirst: Theme.of(context).colorScheme.brightness == Brightness.dark,
    );
  }

  List<AlertDialogAction<ThemeMode>> get themeModeActions {
    return ThemeMode.values.map((e) {
      return AlertDialogAction(
        key: e,
        label: e.name.capitalize,
      );
    }).toList();
  }
}

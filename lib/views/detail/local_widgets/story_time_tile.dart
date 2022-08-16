import 'package:community_material_icon/community_material_icon.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart' as dn;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/db/models/story_db_model.dart';
import 'package:spooky/theme/m3/m3_text_theme.dart';
import 'package:spooky/theme/theme_config.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/views/detail/detail_view_model.dart';

class StoryTimeTile extends StatefulWidget {
  const StoryTimeTile({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final DetailViewModel viewModel;

  @override
  State<StoryTimeTile> createState() => _StoryTimeTileState();
}

class _StoryTimeTileState extends State<StoryTimeTile> {
  late StoryDbModel currentStory;

  @override
  void initState() {
    currentStory = widget.viewModel.currentStory;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    currentStory = widget.viewModel.currentStory;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant StoryTimeTile oldWidget) {
    currentStory = widget.viewModel.currentStory;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox(
        height: 44,
        child: Icon(CommunityMaterialIcons.clock),
      ),
      title: Text(tr("title.time.title")),
      subtitle: Text(DateFormatHelper.timeFormat().format(currentStory.displayPathDate)),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        DateTime? dateTime;

        await Navigator.of(context).push(
          dn.showPicker(
            context: context,
            value: TimeOfDay.fromDateTime(currentStory.displayPathDate),
            okStyle: TextStyle(fontFamily: M3TextTheme.of(context).labelLarge?.fontFamily),
            cancelStyle: TextStyle(fontFamily: M3TextTheme.of(context).labelLarge?.fontFamily),
            buttonStyle: ThemeConfig.isApple(Theme.of(context).platform)
                ? ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent))
                : null,
            onCancel: () {
              Navigator.of(context).pop();
            },
            onChangeDateTime: (date) {
              dateTime = date;
            },
            onChange: (time) {},
          ),
        );

        if (dateTime != null) {
          // DateTime date = currentStory.displayPathDate;
          // StoryDbModel story = await widget.viewModel.setPathDate(DateTime(
          //   date.year,
          //   date.month,
          //   date.day,
          //   dateTime?.hour ?? date.hour,
          //   dateTime?.minute ?? date.minute,
          //   date.second,
          //   date.millisecond,
          //   date.microsecond,
          // ));

          // setState(() {
          //   currentStory = story;
          // });
        }
      },
    );
  }
}

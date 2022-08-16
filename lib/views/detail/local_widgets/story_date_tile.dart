import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/utils/util_widgets/sp_date_picker.dart';
import 'package:spooky/views/detail/detail_view_model.dart';

class StoryDateTile extends StatelessWidget {
  const StoryDateTile({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final DetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const SizedBox(
        height: 44,
        child: Icon(Icons.date_range),
      ),
      title: Text(tr("tile.date.title")),
      subtitle: Text(DateFormatHelper.dateFormat().format(viewModel.currentStory.displayPathDate)),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        DateTime? pathDate = await SpDatePicker.showDatePicker(
          context,
          viewModel.currentStory.displayPathDate,
        );

        if (pathDate != null) {
          // DateTime date = viewModel.currentStory.displayPathDate;
          // viewModel.setPathDate(DateTime(
          //   pathDate.year,
          //   pathDate.month,
          //   pathDate.day,
          //   date.hour,
          //   date.minute,
          //   date.second,
          //   date.millisecond,
          //   date.microsecond,
          // ));
        }
      },
    );
  }
}

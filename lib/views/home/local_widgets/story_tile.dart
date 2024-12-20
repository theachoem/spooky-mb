import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/story_content_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/core/services/color_from_day_service.dart';
import 'package:spooky/views/home/home_view_model.dart';

class StoryTile extends StatelessWidget {
  const StoryTile({
    super.key,
    required this.circleSize,
    required this.story,
    required this.lastChangedStory,
    required this.displayBody,
    required this.viewModel,
  });

  final double circleSize;
  final StoryDbModel story;
  final StoryContentDbModel? lastChangedStory;
  final String? displayBody;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: ColorFromDayService(context: context).get(story.displayPathDate.weekday),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          story.displayPathDate.day.toString(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      title: Text(lastChangedStory?.title ?? 'N/A'),
      subtitle: displayBody != null ? Text(displayBody!) : null,
      onTap: () => viewModel.goToViewPage(context, story),
    );
  }
}

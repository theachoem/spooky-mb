import 'package:flutter/material.dart';
import 'package:spooky/core/databases/models/collection_db_model.dart';
import 'package:spooky/core/databases/models/story_db_model.dart';
import 'package:spooky/widgets/story_list/story_list.dart';

class BackupStoriesTableViewer extends StatelessWidget {
  const BackupStoriesTableViewer({
    super.key,
    required this.stories,
  });

  final List<StoryDbModel> stories;

  @override
  Widget build(BuildContext context) {
    return StoryList(
      viewOnly: true,
      stories: CollectionDbModel(items: stories),
      onChanged: (_) {},
      onDeleted: () {},
    );
  }
}

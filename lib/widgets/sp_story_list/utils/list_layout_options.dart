part of sp_story_list;

class _ListLayoutOptions {
  _ListLayoutOptions({
    required this.stories,
    this.controller,
    this.viewOnly = false,
  });

  final List<StoryDbModel> stories;
  final ScrollController? controller;
  final bool viewOnly;
}

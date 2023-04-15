part of '../home_view_model.dart';

mixin _HomeViewModelTabBarable on BaseViewModel {
  late List<HomeTabItem> _tabs;
  late int _initialTabIndex;

  List<HomeTabItem> get tabs => _tabs;
  int get initialTabIndex => _initialTabIndex;
  SpListLayoutType get layoutType => StoryConfigStorage.instance.layoutType;

  /// Reload tab base on database tags
  void reloadTabs() async {
    if (layoutType != SpListLayoutType.library) return;

    final currentTagIndexes = tabs.where((e) => e.tag?.id != 0).map((e) => "${e.id}${e.label}").toList();
    final newTagIndexes = StoryTagsService.instance.tags.map((e) => "${e.id}${e.title}").toList();

    if (!listEquals(currentTagIndexes, newTagIndexes)) {
      final newTabs = toTabs(StoryTagsService.instance.displayTags);
      final tabChanged = _tabs.length != newTabs.length;
      _tabs = newTabs;

      // by default, view are update state without call notifyListener [except update].
      // Anyway, in case length changed, we have to reload state to update [DefaultTabController]
      if (tabChanged) notifyListeners();
    }
  }

  List<HomeTabItem> toTabs(List<TagDbModel> tags) {
    List<TagDbModel> tagsModified = [
      TagDbModel.fromIDTitle(0, "*"),
      ...tags,
      TagDbModel.fromIDTitle(0, tr("tag.all")),
    ];
    return tagsModified.map(HomeTabItem.fromTag).toList();
  }

  void update(HomeTabItem tab, BuildContext context) async {
    if (layoutType != SpListLayoutType.library) return;

    final TagDbModel? tag = tab.tag;
    if (tag == null) return;

    await StoryTagsService.instance.update(context, tag);
    reloadTabs();

    // [reloadTabs] doesn't call [notifyListeners] as it only call
    // on length updated, so [update] call in its own scope.
    notifyListeners();
  }

  void removeTab(HomeTabItem tab, BuildContext context) async {
    if (layoutType != SpListLayoutType.library) return;

    final TagDbModel? tag = tab.tag;
    if (tag == null) return;

    await StoryTagsService.instance.delete(context, tag);
    reloadTabs();
  }

  void reorder(
    int oldIndex,
    int newIndex,
    BuildContext context,
  ) {
    if (layoutType != SpListLayoutType.library) return;

    if (newIndex == 0 || oldIndex == 0) return;
    if (newIndex == tabs.length || oldIndex == tabs.length) return;

    // -1 because we have default starred tab
    StoryTagsService.instance.reorder(
      oldIndex: oldIndex - 1,
      newIndex: newIndex - 1,
      displayTag: true,
      beforeSave: (tags) {
        _tabs = toTabs(tags);
        notifyListeners();
        return tags;
      },
    );
  }
}

part of '../home_view_model.dart';

class HomeTabItem {
  final int id;
  final String label;
  final TagDbModel? tag;

  HomeTabItem(
    this.id,
    this.label,
    this.tag,
  );

  factory HomeTabItem.fromTag(TagDbModel tag) {
    return HomeTabItem(tag.id, tag.title, tag);
  }

  factory HomeTabItem.fromIndexToMonth(int index) {
    final int monthIndex = index + 1;
    final String monthName = DateFormatHelper.toNameOfMonth().format(DateTime(1999, monthIndex));
    return HomeTabItem(index + 1, monthName, null);
  }
}

import 'package:firebase_analytics/firebase_analytics.dart';

abstract class BaseSelectItemEvent {
  String get itemListName;

  Future<void> log({
    required String itemListId,
    required List<AnalyticsEventItem> items,
  }) {
    return FirebaseAnalytics.instance.logSelectItem(
      itemListId: itemListId,
      items: items,
    );
  }
}

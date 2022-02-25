abstract class BaseNotificationPayload {
  Map<String, String> toPayload() {
    Iterable<MapEntry<String, dynamic>> entries = toJson().entries;
    return {for (MapEntry<String, dynamic> e in entries) e.key: "${e.value}"};
  }

  Map<String, dynamic> toJson();
}

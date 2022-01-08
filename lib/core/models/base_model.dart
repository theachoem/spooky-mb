abstract class BaseModel {
  String? get objectId;

  String get payload => Uri(
        queryParameters: routePayload,
        path: displayRouteName,
      ).toString();

  String get displayRouteName;

  Map<String, String> get routePayload;
  Map<String, dynamic> toJson();
}

import 'package:spooky/core/models/base_model.dart';

abstract class BaseRouteModel extends BaseModel {
  String get payload => Uri(
        queryParameters: routePayload,
        path: displayRouteName,
      ).toString();

  String get displayRouteName;
  Map<String, String> get routePayload;
}

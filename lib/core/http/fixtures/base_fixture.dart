import 'dart:convert';

import 'package:dio/dio.dart';

abstract class BaseFixture {
  int? get statusCode;
  Map<String, dynamic>? get data;

  Response response(RequestOptions options) {
    return Response(
      data: jsonEncode(data),
      requestOptions: options,
      statusCode: statusCode,
    );
  }
}

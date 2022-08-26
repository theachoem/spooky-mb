import 'package:spooky/core/http/fixtures/base_fixture.dart';

class SampleGetUserFixture extends BaseFixture {
  @override
  int? get statusCode => 200;

  @override
  Map<String, dynamic> get data {
    return {
      "data": {
        "id": "1",
        "type": "users",
        "attributes": {
          "email": "john@infinum.co",
          "username": "john",
        }
      }
    };
  }
}

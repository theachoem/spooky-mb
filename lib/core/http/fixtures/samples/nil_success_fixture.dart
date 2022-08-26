import 'package:spooky/core/http/fixtures/base_fixture.dart';

class NilSuccessFixture extends BaseFixture {
  @override
  int? get statusCode => 200;

  @override
  Map<String, dynamic>? get data {
    return null;
  }
}

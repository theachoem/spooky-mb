import 'package:spooky/core/http/fixtures/base_fixture.dart';

class NilErrorFixture extends BaseFixture {
  @override
  int? get statusCode => 404;

  @override
  Map<String, dynamic>? get data {
    return null;
  }
}

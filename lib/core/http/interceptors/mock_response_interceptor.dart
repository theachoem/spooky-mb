import 'package:spooky/core/http/fixtures/base_fixture.dart';
import 'package:dio/dio.dart';

class MockResponseInterceptor<T extends BaseFixture> extends InterceptorsWrapper {
  final T fixture;
  MockResponseInterceptor(this.fixture);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Response<dynamic> response = fixture.response(options);
    return handler.resolve(response, true);
  }
}

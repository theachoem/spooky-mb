import 'package:dio/dio.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final String? accessToken;
  TokenInterceptor(this.accessToken);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = getToken(options.headers);
    return super.onRequest(options, handler);
  }

  Map<String, dynamic> getToken(Map<String, dynamic> headers) {
    dynamic authorization = headers['authorization'];
    if (authorization == null) headers['authorization'] = 'Bearer $accessToken';
    return headers;
  }
}

import 'package:spooky/main.dart';
import 'package:dio/dio.dart';

class DefaultInterceptor extends InterceptorsWrapper {
  final String baseUrl;

  DefaultInterceptor({
    required this.baseUrl,
  }) : assert(!baseUrl.endsWith("/"));

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.baseUrl = "$baseUrl/";

    Map<String, dynamic> headers = options.headers;
    headers['Cm-Api-Version'] = '1.0.0';
    headers['Cm-App-Version'] = Global.instance.platform.version;
    options.headers = headers;

    super.onRequest(options, handler);
  }
}

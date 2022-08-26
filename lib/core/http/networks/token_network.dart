import 'package:spooky/core/http/interceptors/token_interceptor.dart';
import 'package:spooky/core/http/networks/base_network.dart';

abstract class TokenNetwork extends BaseNetwork {
  TokenNetwork(super.baseUrl);
  Future<String?> getAccessToken();

  @override
  Future<BaseNetwork> build() async {
    String? accessToken = await getAccessToken();
    addInterceptor(TokenInterceptor(accessToken), priority: true);
    return super.build();
  }
}

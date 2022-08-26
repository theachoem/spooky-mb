import 'package:spooky/core/http/networks/token_network.dart';
import 'package:spooky/core/storages/local_storages/app_token_storage.dart';

class AppTokenNetwork extends TokenNetwork {
  AppTokenNetwork(super.baseUrl);

  @override
  Future<String?> getAccessToken() async {
    Map<String, dynamic>? result = await AppTokenStorage().readMap();
    return result?['access_token'];
  }
}

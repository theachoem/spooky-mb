import 'package:spooky/core/http/networks/token_network.dart';
import 'package:spooky/core/storages/local_storages/user_token_storage.dart';

class UserTokenNetwork extends TokenNetwork {
  UserTokenNetwork(super.baseUrl);

  @override
  Future<String?> getAccessToken() async {
    Map<String, dynamic>? result = await UserTokenStorage().readMap();
    return result?['access_token'];
  }
}

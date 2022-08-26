import 'package:spooky/core/http/apis/base_resource_owner_api.dart';
import 'package:spooky/core/http/fixtures/samples/nil_success_fixture.dart';
import 'package:spooky/core/http/interceptors/mock_response_interceptor.dart';
import 'package:spooky/core/models/commons/object_list_model.dart';
import 'package:spooky/core/models/samples/article_model.dart';
import 'package:spooky/core/storages/local_storages/user_token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeApi extends BaseResourceOwnerApi<ArticleModel> {
  @override
  String get nameInUrl => "fake";

  @override
  Future<ArticleModel?> objectTransformer(Map<String, dynamic>? json) async {
    return null;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  group("BaseResourceOwnerApi", () {
    test("it return header with resource owner authorization after request", () async {
      UserTokenStorage storage = UserTokenStorage();
      await storage.writeMap({
        "access_token": "FAKE-ACCESS-TOKEN",
        "token_type": "Bearer",
        "expires_in": 123456,
        "refresh_token": "FAKE-REFRESH-TOKEN",
        "created_at": 12345678
      });

      MockResponseInterceptor interceptor = MockResponseInterceptor<NilSuccessFixture>(NilSuccessFixture());
      FakeApi fakeApi = FakeApi()..network.addInterceptor(interceptor);

      ObjectListModel<ArticleModel>? result = await fakeApi.fetchAll();
      Map<String, dynamic>? headers = fakeApi.response?.requestOptions.headers;

      expect(result == null, true);
      expect(headers!['authorization'], "Bearer FAKE-ACCESS-TOKEN");
      expect(headers['Cm-App-Version'], "1.0.0");
      expect(headers['Cm-Api-Version'], "1.0.0");
    });
  });
}

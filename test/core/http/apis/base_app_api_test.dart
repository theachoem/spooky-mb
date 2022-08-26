import 'package:spooky/core/http/apis/base_app_api.dart';
import 'package:spooky/core/http/fixtures/samples/nil_success_fixture.dart';
import 'package:spooky/core/http/interceptors/mock_response_interceptor.dart';
import 'package:spooky/core/models/commons/object_list_model.dart';
import 'package:spooky/core/models/samples/article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spooky/core/storages/local_storages/app_token_storage.dart';

class FakeApi extends BaseAppApi<ArticleModel> {
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

  group("BaseAppApi", () {
    test("it return header with app authorization after request", () async {
      AppTokenStorage storage = AppTokenStorage();
      await storage.writeMap({
        "access_token": "FAKE-ACCESS-TOKEN-123",
        "token_type": "Bearer",
        "expires_in": 123456,
        "created_at": 1234567,
      });

      MockResponseInterceptor interceptor = MockResponseInterceptor<NilSuccessFixture>(NilSuccessFixture());
      FakeApi fakeApi = FakeApi()..network.addInterceptor(interceptor);

      ObjectListModel<ArticleModel>? result = await fakeApi.fetchAll();
      Map<String, dynamic>? headers = fakeApi.response?.requestOptions.headers;

      expect(result == null, true);
      expect(headers!['authorization'], "Bearer FAKE-ACCESS-TOKEN-123");
      expect(headers['Cm-App-Version'], "1.0.0");
      expect(headers['Cm-Api-Version'], "1.0.0");
    });
  });
}

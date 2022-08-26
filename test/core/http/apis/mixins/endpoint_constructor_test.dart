import 'package:spooky/core/http/apis/mixins/endpoint_constructor.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAPI with EndpointConstructor {
  @override
  String get nameInUrl => "articles";

  @override
  String get path => "api/v2";
}

void main() {
  FakeAPI fakeAPI = FakeAPI();

  group('EndpointConstructor', () {
    test('it return a path of no assertion methods', () {
      expect(fakeAPI.createUrl(), "api/v2/articles");
      expect(fakeAPI.fetchAllUrl(), "api/v2/articles");
    });

    test('it throw error when path is a collections but no id', () {
      expect(() => fakeAPI.fetchOneUrl(id: null, collection: true), throwsAssertionError);
      expect(() => fakeAPI.deletelUrl(id: null, collection: true), throwsAssertionError);
      expect(() => fakeAPI.updatelUrl(id: null, collection: true), throwsAssertionError);
    });

    test('it return a path of a item in collections', () {
      expect(fakeAPI.fetchOneUrl(id: "1", collection: true), "api/v2/articles/1");
      expect(fakeAPI.deletelUrl(id: "1", collection: true), "api/v2/articles/1");
      expect(fakeAPI.updatelUrl(id: "1", collection: true), "api/v2/articles/1");
    });

    test('it return a path of an object', () {
      expect(fakeAPI.fetchOneUrl(collection: false), "api/v2/articles");
      expect(fakeAPI.deletelUrl(collection: false), "api/v2/articles");
      expect(fakeAPI.updatelUrl(collection: false), "api/v2/articles");
    });
  });
}

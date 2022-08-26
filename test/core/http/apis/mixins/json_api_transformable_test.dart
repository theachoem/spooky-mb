import 'package:spooky/core/http/apis/mixins/json_api_transformable.dart';
import 'package:spooky/core/models/commons/object_list_model.dart';
import 'package:spooky/core/models/samples/article_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

ArticleModel _objectTransformer(Map<String, dynamic> json) {
  return ArticleModel.fromJson(json);
}

class FakeApi with JsonApiTransformable<ArticleModel> {
  @override
  Future<ArticleModel?> objectTransformer(Map<String, dynamic>? json) async {
    if (json == null) return null;
    return compute(_objectTransformer, json);
  }
}

void main() {
  group('JsonApiTransformable#objectTransformer', () {
    test('it return null when json is empty', () async {
      Map<String, dynamic> json = {};
      ArticleModel? tranformedObject = await FakeApi().objectTransformer(json);

      expect(tranformedObject == null, false);
      expect(tranformedObject?.type, null);
      expect(tranformedObject?.id, null);
      expect(tranformedObject?.type, null);
    });

    test('it decoded & tranformed object from json with compute to avoid lag', () async {
      Map<String, dynamic> json = {
        "data": {
          "type": "articles",
          "id": "1",
          "attributes": {
            "title": "JSON API paints my bikeshed!",
            "created": "2015-05-22T14:56:29.000Z",
          },
          "relationships": {
            "author": {
              "data": {"id": "42", "type": "people"}
            }
          },
        },
        "included": [
          {
            "type": "people",
            "id": "42",
            "attributes": {"name": "John", "age": 80, "gender": "male"}
          }
        ]
      };

      Map<String, dynamic> decodedJson = FakeApi().decodeJson(json);
      ArticleModel? tranformedObject = await FakeApi().objectTransformer(decodedJson['data']);

      expect(tranformedObject == null, false);
      expect(tranformedObject?.type, "articles");
      expect(tranformedObject?.id, "1");

      expect(tranformedObject?.created?.day, 22);
      expect(tranformedObject?.created?.month, 5);
      expect(tranformedObject?.created?.year, 2015);

      expect(tranformedObject?.author?.name, "John");
      expect(tranformedObject?.author?.age, 80);
      expect(tranformedObject?.author?.gender, "male");
    });
  });

  group('JsonApiTransformable#itemsTransformer', () {
    test('it return 0 item when json is empty', () async {
      Map<String, dynamic> json = {};
      ObjectListModel<ArticleModel>? decodedList = await FakeApi().itemsTransformer(json);

      expect(decodedList?.items.length, 0);
      expect(decodedList?.items.length, 0);

      expect(decodedList?.meta, null);
      expect(decodedList?.links, null);
    });

    test('it decode & tranformed items from json with compute', () async {
      Map<String, dynamic> json = {
        "data": [
          {
            "type": "articles",
            "id": "1",
            "attributes": {
              "title": "JSON API paints my bikeshed!",
              "body": "The shortest article. Ever.",
              "created": "2015-05-22T14:56:29.000Z",
            },
            "relationships": {
              "author": {
                "data": {"id": "42", "type": "people"}
              }
            }
          }
        ],
        "included": [
          {
            "type": "people",
            "id": "42",
            "attributes": {"name": "John", "age": 80, "gender": "male"}
          }
        ],
        "meta": {
          'count': 1,
          'total_count': 2,
          'total_pages': 3,
          'current_page': 4,
          'unread_count': null,
        },
        "links": {
          'self': "https://example.com?page=1",
          'next': "https://example.com?page=2",
          'prev': "https://example.com?page=3",
          'last': "https://example.com?page=4",
          'first': null,
        }
      };

      Map<String, dynamic> decodedJson = FakeApi().decodeJson(json);
      ObjectListModel<ArticleModel>? decodedList = await FakeApi().itemsTransformer(decodedJson);

      expect(decodedList?.items.length, 1);
      expect(decodedList?.items[0].title, "JSON API paints my bikeshed!");
      expect(decodedList?.items[0].author?.name, "John");
      expect(decodedList?.items[0].author?.age, 80);
      expect(decodedList?.items[0].author?.gender, "male");

      expect(decodedList?.items[0].created?.day, 22);
      expect(decodedList?.items[0].created?.month, 5);
      expect(decodedList?.items[0].created?.year, 2015);

      expect(decodedList?.meta?.count, 1);
      expect(decodedList?.meta?.totalCount, 2);
      expect(decodedList?.meta?.totalPages, 3);
      expect(decodedList?.meta?.currentPage, 4);
      expect(decodedList?.meta?.unreadCount, null);

      expect(decodedList?.links?.self, "https://example.com?page=1");
      expect(decodedList?.links?.next, "https://example.com?page=2");
      expect(decodedList?.links?.prev, "https://example.com?page=3");
      expect(decodedList?.links?.last, "https://example.com?page=4");
      expect(decodedList?.links?.first, null);
    });
  });
}

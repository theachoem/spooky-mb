import 'package:spooky/core/http/fixtures/base_fixture.dart';

class SampleGetArticleFixture extends BaseFixture {
  @override
  int? get statusCode => 200;

  @override
  Map<String, dynamic>? get data {
    return {
      "data": {
        "type": "articles",
        "id": "1",
        "attributes": {
          "title": "JSON API paints my bikeshed!",
          "body": "The shortest article. Ever.",
          "created": "2015-05-22T14:56:29.000Z",
          "updated": "2015-05-22T14:56:28.000Z"
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
  }
}

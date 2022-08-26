import 'package:spooky/core/http/apis/mixins/endpoint_constructor.dart';
import 'package:spooky/core/http/apis/mixins/json_api_transformable.dart';
import 'package:spooky/core/http/networks/base_network.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/commons/object_list_model.dart';
import 'package:dio/dio.dart';

abstract class BaseApi<T extends BaseModel> with JsonApiTransformable<T>, EndpointConstructor {
  @override
  String get path => "api/v2";

  // ABSTRACT
  BaseNetwork buildNetwork();

  Response<dynamic>? response;
  late final BaseNetwork network;

  BaseApi() {
    network = buildNetwork();
  }

  Dio? _http;
  Future<Dio> get http async {
    _http ??= await network.build().then((network) => network.http);
    return _http!;
  }

  bool success() {
    if (response != null) {
      return response!.statusCode! >= 200 && response!.statusCode! < 300;
    }
    return false;
  }

  Future<ObjectListModel<T>?> fetchAll({
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters = await mergeLocale(queryParameters);
    String endpoint = fetchAllUrl();

    response = await http.then((http) {
      return http.get(
        endpoint,
        queryParameters: queryParameters,
      );
    });

    return itemsTransformer(
      decodeResponse(response!),
    );
  }

  Future<T?> fetchOne({
    String? id,
    bool collection = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters = await mergeLocale(queryParameters);

    String endpoint = fetchOneUrl(id: id, collection: collection);
    response = await http.then((http) {
      return http.get(endpoint, queryParameters: queryParameters);
    });

    return objectTransformer(
      decodeResponse(response!)?['data'],
    );
  }

  Future<T?> create({
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters = await mergeLocale(queryParameters);
    String endpoint = createUrl();

    response = await http.then((http) {
      return http.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
    });

    return objectTransformer(
      decodeResponse(response!),
    );
  }

  Future<T?> update({
    String? id,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool collection = true,
  }) async {
    queryParameters = await mergeLocale(queryParameters);
    String endpoint = updatelUrl(id: id, collection: collection);

    if (data?.isNotEmpty == true) {
      response = await http.then((http) {
        return http.put(
          endpoint,
          data: data,
          queryParameters: queryParameters,
        );
      });
    } else {
      response = await http.then((http) {
        return http.patch(
          endpoint,
          queryParameters: queryParameters,
        );
      });
    }

    return objectTransformer(
      decodeResponse(response!),
    );
  }

  Future<void> delete({
    String? id,
    Map<String, dynamic>? queryParameters,
    bool collection = true,
  }) async {
    queryParameters = await mergeLocale(queryParameters);
    String endpoint = deletelUrl(id: id, collection: collection);
    response = await http.then((http) {
      return http.delete(
        endpoint,
        queryParameters: queryParameters,
      );
    });
  }

  Future<Map<String, dynamic>> mergeLocale(Map<String, dynamic>? params) async {
    params ??= {};
    if (params.containsKey('locale')) {
      return params;
    } else {
      params['locale'] = "en";
      return params;
    }
  }
}

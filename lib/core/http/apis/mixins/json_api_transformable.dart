import 'dart:convert';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/commons/links_model.dart';
import 'package:spooky/core/models/commons/meta_model.dart';
import 'package:spooky/core/models/commons/object_list_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:japx/japx.dart';

mixin JsonApiTransformable<T extends BaseModel> {
  Future<T?> objectTransformer(Map<String, dynamic>? json);

  Future<ObjectListModel<T>?> itemsTransformer(Map<String, dynamic>? json) async {
    if (json == null) return null;

    List<T>? items = await buildItemsList(json);
    MetaModel? meta = buildMetaModel(json);
    LinksModel? links = buildLinkModel(json);

    ObjectListModel<T>? objectList = ObjectListModel<T>(
      items: items ?? [],
      links: links,
      meta: meta,
    );

    return objectList;
  }

  MetaModel? buildMetaModel(Map<String, dynamic> json) {
    dynamic meta = json['meta'];
    if (meta is Map<String, dynamic>) return MetaModel.fromJson(meta);
    return null;
  }

  LinksModel? buildLinkModel(Map<String, dynamic> json) {
    dynamic links = json['links'];
    if (links is Map<String, dynamic>) return LinksModel.fromJson(links);
    return null;
  }

  Future<List<T>?> buildItemsList(Map<String, dynamic> json) async {
    dynamic items = json['data'];
    if (items is! List) return null;

    List<T> records = [];

    for (dynamic attrs in items) {
      T? record = await objectTransformer(attrs ?? {});
      if (record != null) records.add(record);
    }

    return records;
  }

  Map<String, dynamic> decodeJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = Japx.decode(json);
    return data;
  }

  Map<String, dynamic>? decodeResponse(Response<dynamic> response) {
    dynamic json = response.data;

    if (json is String) {
      try {
        json = jsonDecode(json);
      } catch (e) {
        throw ErrorSummary("decodeResponse(): $e");
      }
    }

    if (json is Map<String, dynamic>) return decodeJson(json);
    return null;
  }
}

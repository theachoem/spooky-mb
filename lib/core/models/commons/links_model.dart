import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'links_model.g.dart';

@CopyWith()
@JsonSerializable()
class LinksModel extends BaseModel {
  final String? self;
  final String? next;
  final String? prev;
  final String? last;
  final String? first;

  LinksModel({
    this.self,
    this.next,
    this.prev,
    this.last,
    this.first,
  });

  LinksModel getPageNumber() {
    LinksModel newLinks = LinksModel(
      first: AppHelper.queryParameters(url: first ?? "", param: 'page'),
      last: AppHelper.queryParameters(url: last ?? "", param: 'page'),
      next: AppHelper.queryParameters(url: next ?? "", param: 'page'),
      prev: AppHelper.queryParameters(url: prev ?? "", param: 'page'),
      self: AppHelper.queryParameters(url: self ?? "", param: 'page'),
    );
    return newLinks;
  }

  @override
  Map<String, dynamic> toJson() => _$LinksModelToJson(this);
  factory LinksModel.fromJson(Map<String, dynamic> json) => _$LinksModelFromJson(json);

  @override
  String? get objectId => toJson().values.join("-");
}

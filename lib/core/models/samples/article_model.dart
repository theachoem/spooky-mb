import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/samples/author_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article_model.g.dart';

@CopyWith()
@JsonSerializable()
class ArticleModel extends BaseModel {
  ArticleModel({
    this.type,
    this.id,
    this.title,
    this.body,
    this.created,
    this.updated,
    this.author,
  });

  final String? type;
  final String? id;
  final String? title;
  final String? body;
  final DateTime? created;
  final DateTime? updated;
  final AuthorModel? author;

  @override
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
  factory ArticleModel.fromJson(Map<String, dynamic> json) => _$ArticleModelFromJson(json);

  @override
  String? get objectId => id;
}

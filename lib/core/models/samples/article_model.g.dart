// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ArticleModelCWProxy {
  ArticleModel type(String? type);

  ArticleModel id(String? id);

  ArticleModel title(String? title);

  ArticleModel body(String? body);

  ArticleModel created(DateTime? created);

  ArticleModel updated(DateTime? updated);

  ArticleModel author(AuthorModel? author);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ArticleModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ArticleModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ArticleModel call({
    String? type,
    String? id,
    String? title,
    String? body,
    DateTime? created,
    DateTime? updated,
    AuthorModel? author,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfArticleModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfArticleModel.copyWith.fieldName(...)`
class _$ArticleModelCWProxyImpl implements _$ArticleModelCWProxy {
  const _$ArticleModelCWProxyImpl(this._value);

  final ArticleModel _value;

  @override
  ArticleModel type(String? type) => this(type: type);

  @override
  ArticleModel id(String? id) => this(id: id);

  @override
  ArticleModel title(String? title) => this(title: title);

  @override
  ArticleModel body(String? body) => this(body: body);

  @override
  ArticleModel created(DateTime? created) => this(created: created);

  @override
  ArticleModel updated(DateTime? updated) => this(updated: updated);

  @override
  ArticleModel author(AuthorModel? author) => this(author: author);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ArticleModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ArticleModel(...).copyWith(id: 12, name: "My name")
  /// ````
  ArticleModel call({
    Object? type = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? created = const $CopyWithPlaceholder(),
    Object? updated = const $CopyWithPlaceholder(),
    Object? author = const $CopyWithPlaceholder(),
  }) {
    return ArticleModel(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String?,
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String?,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String?,
      created: created == const $CopyWithPlaceholder()
          ? _value.created
          // ignore: cast_nullable_to_non_nullable
          : created as DateTime?,
      updated: updated == const $CopyWithPlaceholder()
          ? _value.updated
          // ignore: cast_nullable_to_non_nullable
          : updated as DateTime?,
      author: author == const $CopyWithPlaceholder()
          ? _value.author
          // ignore: cast_nullable_to_non_nullable
          : author as AuthorModel?,
    );
  }
}

extension $ArticleModelCopyWith on ArticleModel {
  /// Returns a callable class that can be used as follows: `instanceOfArticleModel.copyWith(...)` or like so:`instanceOfArticleModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ArticleModelCWProxy get copyWith => _$ArticleModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) => ArticleModel(
      type: json['type'] as String?,
      id: json['id'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      updated: json['updated'] == null
          ? null
          : DateTime.parse(json['updated'] as String),
      author: json['author'] == null
          ? null
          : AuthorModel.fromJson(json['author'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArticleModelToJson(ArticleModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'created': instance.created?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
      'author': instance.author?.toJson(),
    };

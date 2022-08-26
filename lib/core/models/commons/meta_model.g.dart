// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MetaModelCWProxy {
  MetaModel count(int? count);

  MetaModel currentPage(int? currentPage);

  MetaModel totalCount(int? totalCount);

  MetaModel totalPages(int? totalPages);

  MetaModel unreadCount(int? unreadCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MetaModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MetaModel(...).copyWith(id: 12, name: "My name")
  /// ````
  MetaModel call({
    int? count,
    int? currentPage,
    int? totalCount,
    int? totalPages,
    int? unreadCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMetaModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMetaModel.copyWith.fieldName(...)`
class _$MetaModelCWProxyImpl implements _$MetaModelCWProxy {
  final MetaModel _value;

  const _$MetaModelCWProxyImpl(this._value);

  @override
  MetaModel count(int? count) => this(count: count);

  @override
  MetaModel currentPage(int? currentPage) => this(currentPage: currentPage);

  @override
  MetaModel totalCount(int? totalCount) => this(totalCount: totalCount);

  @override
  MetaModel totalPages(int? totalPages) => this(totalPages: totalPages);

  @override
  MetaModel unreadCount(int? unreadCount) => this(unreadCount: unreadCount);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MetaModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MetaModel(...).copyWith(id: 12, name: "My name")
  /// ````
  MetaModel call({
    Object? count = const $CopyWithPlaceholder(),
    Object? currentPage = const $CopyWithPlaceholder(),
    Object? totalCount = const $CopyWithPlaceholder(),
    Object? totalPages = const $CopyWithPlaceholder(),
    Object? unreadCount = const $CopyWithPlaceholder(),
  }) {
    return MetaModel(
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as int?,
      currentPage: currentPage == const $CopyWithPlaceholder()
          ? _value.currentPage
          // ignore: cast_nullable_to_non_nullable
          : currentPage as int?,
      totalCount: totalCount == const $CopyWithPlaceholder()
          ? _value.totalCount
          // ignore: cast_nullable_to_non_nullable
          : totalCount as int?,
      totalPages: totalPages == const $CopyWithPlaceholder()
          ? _value.totalPages
          // ignore: cast_nullable_to_non_nullable
          : totalPages as int?,
      unreadCount: unreadCount == const $CopyWithPlaceholder()
          ? _value.unreadCount
          // ignore: cast_nullable_to_non_nullable
          : unreadCount as int?,
    );
  }
}

extension $MetaModelCopyWith on MetaModel {
  /// Returns a callable class that can be used as follows: `instanceOfMetaModel.copyWith(...)` or like so:`instanceOfMetaModel.copyWith.fieldName(...)`.
  _$MetaModelCWProxy get copyWith => _$MetaModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaModel _$MetaModelFromJson(Map<String, dynamic> json) => MetaModel(
      count: json['count'] as int?,
      totalCount: json['total_count'] as int?,
      totalPages: json['total_pages'] as int?,
      currentPage: json['current_page'] as int?,
      unreadCount: json['unread_count'] as int?,
    );

Map<String, dynamic> _$MetaModelToJson(MetaModel instance) => <String, dynamic>{
      'count': instance.count,
      'total_count': instance.totalCount,
      'total_pages': instance.totalPages,
      'current_page': instance.currentPage,
      'unread_count': instance.unreadCount,
    };

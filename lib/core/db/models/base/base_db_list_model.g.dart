// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_db_list_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BaseDbListModelCWProxy<T extends BaseDbModel> {
  BaseDbListModel<T> items(List<T> items);

  BaseDbListModel<T> meta(MetaDbModel? meta);

  BaseDbListModel<T> links(LinksDbModel? links);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BaseDbListModel<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BaseDbListModel<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  BaseDbListModel<T> call({
    List<T>? items,
    MetaDbModel? meta,
    LinksDbModel? links,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBaseDbListModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBaseDbListModel.copyWith.fieldName(...)`
class _$BaseDbListModelCWProxyImpl<T extends BaseDbModel>
    implements _$BaseDbListModelCWProxy<T> {
  const _$BaseDbListModelCWProxyImpl(this._value);

  final BaseDbListModel<T> _value;

  @override
  BaseDbListModel<T> items(List<T> items) => this(items: items);

  @override
  BaseDbListModel<T> meta(MetaDbModel? meta) => this(meta: meta);

  @override
  BaseDbListModel<T> links(LinksDbModel? links) => this(links: links);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BaseDbListModel<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BaseDbListModel<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  BaseDbListModel<T> call({
    Object? items = const $CopyWithPlaceholder(),
    Object? meta = const $CopyWithPlaceholder(),
    Object? links = const $CopyWithPlaceholder(),
  }) {
    return BaseDbListModel<T>(
      items: items == const $CopyWithPlaceholder() || items == null
          // ignore: unnecessary_non_null_assertion
          ? _value.items!
          // ignore: cast_nullable_to_non_nullable
          : items as List<T>,
      meta: meta == const $CopyWithPlaceholder()
          ? _value.meta
          // ignore: cast_nullable_to_non_nullable
          : meta as MetaDbModel?,
      links: links == const $CopyWithPlaceholder()
          ? _value.links
          // ignore: cast_nullable_to_non_nullable
          : links as LinksDbModel?,
    );
  }
}

extension $BaseDbListModelCopyWith<T extends BaseDbModel>
    on BaseDbListModel<T> {
  /// Returns a callable class that can be used as follows: `instanceOfBaseDbListModel.copyWith(...)` or like so:`instanceOfBaseDbListModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BaseDbListModelCWProxy<T> get copyWith =>
      _$BaseDbListModelCWProxyImpl<T>(this);
}

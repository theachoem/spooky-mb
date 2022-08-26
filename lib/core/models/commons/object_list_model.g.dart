// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_list_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ObjectListModelCWProxy<T extends BaseModel> {
  ObjectListModel<T> items(List<T> items);

  ObjectListModel<T> links(LinksModel? links);

  ObjectListModel<T> meta(MetaModel? meta);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ObjectListModel<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ObjectListModel<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  ObjectListModel<T> call({
    List<T>? items,
    LinksModel? links,
    MetaModel? meta,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfObjectListModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfObjectListModel.copyWith.fieldName(...)`
class _$ObjectListModelCWProxyImpl<T extends BaseModel>
    implements _$ObjectListModelCWProxy<T> {
  final ObjectListModel<T> _value;

  const _$ObjectListModelCWProxyImpl(this._value);

  @override
  ObjectListModel<T> items(List<T> items) => this(items: items);

  @override
  ObjectListModel<T> links(LinksModel? links) => this(links: links);

  @override
  ObjectListModel<T> meta(MetaModel? meta) => this(meta: meta);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ObjectListModel<T>(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ObjectListModel<T>(...).copyWith(id: 12, name: "My name")
  /// ````
  ObjectListModel<T> call({
    Object? items = const $CopyWithPlaceholder(),
    Object? links = const $CopyWithPlaceholder(),
    Object? meta = const $CopyWithPlaceholder(),
  }) {
    return ObjectListModel<T>(
      items: items == const $CopyWithPlaceholder() || items == null
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<T>,
      links: links == const $CopyWithPlaceholder()
          ? _value.links
          // ignore: cast_nullable_to_non_nullable
          : links as LinksModel?,
      meta: meta == const $CopyWithPlaceholder()
          ? _value.meta
          // ignore: cast_nullable_to_non_nullable
          : meta as MetaModel?,
    );
  }
}

extension $ObjectListModelCopyWith<T extends BaseModel> on ObjectListModel<T> {
  /// Returns a callable class that can be used as follows: `instanceOfObjectListModel.copyWith(...)` or like so:`instanceOfObjectListModel.copyWith.fieldName(...)`.
  _$ObjectListModelCWProxy<T> get copyWith =>
      _$ObjectListModelCWProxyImpl<T>(this);
}

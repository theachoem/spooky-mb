// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'links_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LinksModelCWProxy {
  LinksModel self(String? self);

  LinksModel next(String? next);

  LinksModel prev(String? prev);

  LinksModel last(String? last);

  LinksModel first(String? first);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LinksModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LinksModel(...).copyWith(id: 12, name: "My name")
  /// ````
  LinksModel call({
    String? self,
    String? next,
    String? prev,
    String? last,
    String? first,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLinksModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLinksModel.copyWith.fieldName(...)`
class _$LinksModelCWProxyImpl implements _$LinksModelCWProxy {
  const _$LinksModelCWProxyImpl(this._value);

  final LinksModel _value;

  @override
  LinksModel self(String? self) => this(self: self);

  @override
  LinksModel next(String? next) => this(next: next);

  @override
  LinksModel prev(String? prev) => this(prev: prev);

  @override
  LinksModel last(String? last) => this(last: last);

  @override
  LinksModel first(String? first) => this(first: first);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LinksModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LinksModel(...).copyWith(id: 12, name: "My name")
  /// ````
  LinksModel call({
    Object? self = const $CopyWithPlaceholder(),
    Object? next = const $CopyWithPlaceholder(),
    Object? prev = const $CopyWithPlaceholder(),
    Object? last = const $CopyWithPlaceholder(),
    Object? first = const $CopyWithPlaceholder(),
  }) {
    return LinksModel(
      self: self == const $CopyWithPlaceholder()
          ? _value.self
          // ignore: cast_nullable_to_non_nullable
          : self as String?,
      next: next == const $CopyWithPlaceholder()
          ? _value.next
          // ignore: cast_nullable_to_non_nullable
          : next as String?,
      prev: prev == const $CopyWithPlaceholder()
          ? _value.prev
          // ignore: cast_nullable_to_non_nullable
          : prev as String?,
      last: last == const $CopyWithPlaceholder()
          ? _value.last
          // ignore: cast_nullable_to_non_nullable
          : last as String?,
      first: first == const $CopyWithPlaceholder()
          ? _value.first
          // ignore: cast_nullable_to_non_nullable
          : first as String?,
    );
  }
}

extension $LinksModelCopyWith on LinksModel {
  /// Returns a callable class that can be used as follows: `instanceOfLinksModel.copyWith(...)` or like so:`instanceOfLinksModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LinksModelCWProxy get copyWith => _$LinksModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinksModel _$LinksModelFromJson(Map<String, dynamic> json) => LinksModel(
      self: json['self'] as String?,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
      last: json['last'] as String?,
      first: json['first'] as String?,
    );

Map<String, dynamic> _$LinksModelToJson(LinksModel instance) =>
    <String, dynamic>{
      'self': instance.self,
      'next': instance.next,
      'prev': instance.prev,
      'last': instance.last,
      'first': instance.first,
    };

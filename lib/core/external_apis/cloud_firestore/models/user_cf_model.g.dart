// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_cf_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserCfModelCWProxy {
  UserCfModel uid(String? uid);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserCfModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserCfModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserCfModel call({
    String? uid,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserCfModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserCfModel.copyWith.fieldName(...)`
class _$UserCfModelCWProxyImpl implements _$UserCfModelCWProxy {
  final UserCfModel _value;

  const _$UserCfModelCWProxyImpl(this._value);

  @override
  UserCfModel uid(String? uid) => this(uid: uid);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserCfModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserCfModel(...).copyWith(id: 12, name: "My name")
  /// ````
  UserCfModel call({
    Object? uid = const $CopyWithPlaceholder(),
  }) {
    return UserCfModel(
      uid: uid == const $CopyWithPlaceholder()
          ? _value.uid
          // ignore: cast_nullable_to_non_nullable
          : uid as String?,
    );
  }
}

extension $UserCfModelCopyWith on UserCfModel {
  /// Returns a callable class that can be used as follows: `instanceOfUserCfModel.copyWith(...)` or like so:`instanceOfUserCfModel.copyWith.fieldName(...)`.
  _$UserCfModelCWProxy get copyWith => _$UserCfModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCfModel _$UserCfModelFromJson(Map<String, dynamic> json) => UserCfModel(
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$UserCfModelToJson(UserCfModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottom_nav_item_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BottomNavItemListModel _$BottomNavItemListModelFromJson(
        Map<String, dynamic> json) =>
    BottomNavItemListModel(
      (json['items'] as List<dynamic>?)
          ?.map((e) => BottomNavItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BottomNavItemListModelToJson(
        BottomNavItemListModel instance) =>
    <String, dynamic>{
      'items': instance.items?.map((e) => e.toJson()).toList(),
    };

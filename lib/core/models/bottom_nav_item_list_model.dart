import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/bottom_nav_item_model.dart';

part 'bottom_nav_item_list_model.g.dart';

@JsonSerializable()
class BottomNavItemListModel {
  final List<BottomNavItemModel>? items;
  BottomNavItemListModel(this.items);

  Map<String, dynamic> toJson() => _$BottomNavItemListModelToJson(this);
  factory BottomNavItemListModel.fromJson(Map<String, dynamic> json) => _$BottomNavItemListModelFromJson(json);
}

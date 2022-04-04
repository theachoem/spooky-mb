import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/routes/sp_router.dart';

part 'bottom_nav_item_model.g.dart';

@JsonSerializable()
class BottomNavItemModel {
  final SpRouter? router;
  final bool? selected;

  BottomNavItemModel({
    this.router,
    this.selected,
  });

  BottomNavItemModel copyWith({
    SpRouter? router,
    bool? selected,
  }) {
    return BottomNavItemModel(
      router: router ?? this.router,
      selected: selected ?? this.selected,
    );
  }

  Map<String, dynamic> toJson() => _$BottomNavItemModelToJson(this);
  factory BottomNavItemModel.fromJson(Map<String, dynamic> json) {
    final values = SpRouter.values.map((e) => e.name);
    if (values.contains(json['router'])) {
      return _$BottomNavItemModelFromJson(json);
    } else {
      return BottomNavItemModel(router: null);
    }
  }
}

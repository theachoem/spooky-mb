import 'package:json_annotation/json_annotation.dart';
import 'package:spooky/core/models/base_model.dart';

part 'purchased_info_model.g.dart';

@JsonSerializable()
class PurchasedInfoModel extends BaseModel {
  final String? purchaseId;
  final String productId;
  final String? transactionDate;
  final String? uid;
  final List<String>? userProviderIds;

  PurchasedInfoModel(
    this.purchaseId,
    this.productId,
    this.transactionDate,
    this.uid,
    this.userProviderIds,
  );

  @override
  String? get objectId => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() => _$PurchasedInfoModelToJson(this);
  factory PurchasedInfoModel.fromJson(Map<String, dynamic> json) => _$PurchasedInfoModelFromJson(json);
}

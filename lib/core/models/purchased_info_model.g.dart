// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchased_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchasedInfoModel _$PurchasedInfoModelFromJson(Map<String, dynamic> json) =>
    PurchasedInfoModel(
      json['purchase_id'] as String?,
      json['product_id'] as String,
      json['transaction_date'] as String?,
    );

Map<String, dynamic> _$PurchasedInfoModelToJson(PurchasedInfoModel instance) =>
    <String, dynamic>{
      'purchase_id': instance.purchaseId,
      'product_id': instance.productId,
      'transaction_date': instance.transactionDate,
    };

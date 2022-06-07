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
      json['uid'] as String?,
      (json['user_provider_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PurchasedInfoModelToJson(PurchasedInfoModel instance) =>
    <String, dynamic>{
      'purchase_id': instance.purchaseId,
      'product_id': instance.productId,
      'transaction_date': instance.transactionDate,
      'uid': instance.uid,
      'user_provider_ids': instance.userProviderIds,
    };

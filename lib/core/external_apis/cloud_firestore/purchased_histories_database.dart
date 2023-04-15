import 'package:spooky/core/external_apis/cloud_firestore/base_cloud_firestore.dart';
import 'package:spooky/core/models/purchased_info_model.dart';

class PurchaseHistoriesDatabase extends BaseCloudFirestore<PurchasedInfoModel> {
  @override
  String get collectionName => "purchased_histories";

  @override
  PurchasedInfoModel objectTransformer(Map<String, dynamic> json) {
    return PurchasedInfoModel.fromJson(json);
  }

  Future<void> addProduct(PurchasedInfoModel info) async {
    return set(info.purchaseId!, info);
  }
}

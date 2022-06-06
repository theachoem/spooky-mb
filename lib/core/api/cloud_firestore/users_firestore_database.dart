import 'package:spooky/core/api/cloud_firestore/base_cloud_firestore.dart';
import 'package:spooky/core/models/base_model.dart';
import 'package:spooky/core/models/purchased_info_model.dart';

class UsersFirestoreDatabase extends BaseCloudFirestore {
  @override
  String get collectionName => "users";

  @override
  BaseModel objectTransformer(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  Future<void> addProduct(
    String productId,
    String uid,
    PurchasedInfoModel info,
  ) async {
    final productsRef = reference.doc(uid).collection('products');
    await productsRef.doc(productId).set(info.toJson());
  }

  Future<List<PurchasedInfoModel>> fetchPurchasedProducts(String uid) async {
    final productsRef = reference.doc(uid).collection('products');
    final result = await productsRef.get();

    List<PurchasedInfoModel> purchases = [];
    for (final doc in result.docs) {
      final info = PurchasedInfoModel.fromJson(doc.data());
      purchases.add(info);
    }

    return purchases;
  }
}

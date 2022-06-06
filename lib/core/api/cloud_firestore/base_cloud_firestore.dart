import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spooky/core/models/base_model.dart';

abstract class BaseCloudFirestore<T extends BaseModel> {
  String get collectionName;
  late final CollectionReference<Map<String, dynamic>> reference;

  BaseCloudFirestore() {
    reference = FirebaseFirestore.instance.collection(collectionName);
  }

  T objectTransformer(Map<String, dynamic> json);

  Future<T?> get(String id) async {
    final snapshot = await reference.doc(id).get();
    final data = snapshot.data();
    return data != null ? objectTransformer(data) : null;
  }

  Future<void> set(String id, T object) async {
    return reference.doc(id).set(object.toJson());
  }
}

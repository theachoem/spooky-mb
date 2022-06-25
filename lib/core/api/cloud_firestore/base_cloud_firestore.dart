import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spooky/core/models/base_model.dart';

abstract class BaseCloudFirestore<T extends BaseModel> {
  String? errorMessage;
  String get collectionName;
  late final CollectionReference<Map<String, dynamic>> reference;

  BaseCloudFirestore() {
    reference = FirebaseFirestore.instance.collection(collectionName);
  }

  T objectTransformer(Map<String, dynamic> json);

  Future<P?> beforeExec<P>(Future<P?> Function() callback) async {
    try {
      return callback();
    } catch (e) {
      errorMessage = e.toString();
      return null;
    }
  }

  Future<T?> get(String id) async {
    return beforeExec<T>(() async {
      final snapshot = await reference.doc(id).get();
      final data = snapshot.data();
      return data != null ? objectTransformer(data) : null;
    });
  }

  Future<void> set(String id, T object) async {
    return beforeExec(() async {
      reference.doc(id).set(object.toJson(), SetOptions(merge: true));
    });
  }
}

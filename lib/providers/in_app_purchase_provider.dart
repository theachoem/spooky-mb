import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:spooky/core/api/cloud_firestore/users_firestore_database.dart';
import 'package:spooky/core/models/product_list_model.dart';
import 'package:spooky/core/models/purchased_info_model.dart';
import 'package:spooky/core/storages/local_storages/purchased_add_on_storage.dart';
import 'package:spooky/core/types/product_as_type.dart';

class InAppPurchaseProvider extends ChangeNotifier {
  static List<String>? purchases;

  bool purchased(ProductAsType type) {
    return purchases?.contains(type.productId) == true;
  }

  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late final ValueNotifier<List<PurchaseDetails>> purchaseNotifier;
  List<ProductDetails> productDetails = [];

  late final List<String> nonConsumableIds;
  late final List<String> consumableIds;
  Set<String> get productIds => <String>{...nonConsumableIds, ...consumableIds};
  User? get currentUser => FirebaseAuth.instance.currentUser;

  InAppPurchaseProvider() {
    purchaseNotifier = ValueNotifier([]);
    inAppPurchase.isAvailable().then((available) {
      if (!available) return;
      inAppPurchase.purchaseStream.listen(listener);
    });

    // get non & consumable with model
    ProductListModel list = ProductListModel.getter();
    nonConsumableIds = list.products.where((e) => !e.consumable).map((e) => e.type.productId).toList();
    consumableIds = list.products.where((e) => e.consumable).map((e) => e.type.productId).toList();
  }

  static Future<void> initialize() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      PurchasedAddOnStorage storage = PurchasedAddOnStorage();
      purchases = await storage.readList();
      try {
        // UsersFirestoreDatabase database = UsersFirestoreDatabase();
        // FirebaseAuth.instance.currentUser?.uid;
        // database.fetchPurchasedProducts(user.uid).then((list) {
        //   List<String> purchases = list.map((e) => e.productId).toList();
        //   if (purchases.isNotEmpty) {
        //     storage.writeList(purchases);
        //   }
        // });
      } catch (e) {
        if (kDebugMode) rethrow;
      }
    }
  }

  Future<void> loadPurchasedProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      PurchasedAddOnStorage storage = PurchasedAddOnStorage();
      try {
        UsersFirestoreDatabase database = UsersFirestoreDatabase();
        List<PurchasedInfoModel> list = await database.fetchPurchasedProducts(user.uid);
        purchases = list.map((e) => e.productId).toList();
        if (purchases!.isNotEmpty) storage.writeList(purchases!);
        notifyListeners();
      } catch (e) {
        if (kDebugMode) rethrow;
      }
    }
  }

  Future<void> fetchProducts() async {
    bool available = await inAppPurchase.isAvailable();
    if (available == true) {
      ProductDetailsResponse result = await inAppPurchase.queryProductDetails(productIds);
      productDetails = result.productDetails;
      notifyListeners();
    }
  }

  void listener(List<PurchaseDetails> purchaseDetailsList) async {
    purchaseNotifier.value = purchaseDetailsList;
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          bool valid = await verifyPurchase(purchaseDetails);
          if (valid) deliverProduct(purchaseDetails);
          break;
        case PurchaseStatus.pending:
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          break;
      }
      if (Platform.isAndroid && consumableIds.contains(purchaseDetails.productID)) {
        final androidAddition = inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
        await androidAddition.consumePurchase(purchaseDetails);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    UsersFirestoreDatabase database = UsersFirestoreDatabase();
    if (currentUser?.uid != null) {
      await database.addProduct(
        purchaseDetails.productID,
        cacheUid ?? currentUser!.uid,
        PurchasedInfoModel(
          purchaseDetails.purchaseID,
          purchaseDetails.productID,
          purchaseDetails.transactionDate,
        ),
      );
      await loadPurchasedProducts();
    }
  }

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  String? cacheUid;
  Future<void> buyProduct(ProductDetails productDetails) async {
    PurchaseParam? purchaseParam;
    cacheUid = currentUser?.uid;
    if (cacheUid == null) return;

    if (Platform.isAndroid) {
      purchaseParam = GooglePlayPurchaseParam(
        productDetails: productDetails,
        applicationUserName: cacheUid,
      );
    } else if (Platform.isIOS) {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: cacheUid,
      );
    }

    if (purchaseParam != null) {
      if (consumableIds.contains(productDetails.id)) {
        await inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      } else if (nonConsumableIds.contains(productDetails.id)) {
        await inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    }
  }

  void restore() async {
    await inAppPurchase.restorePurchases(
      applicationUserName: cacheUid ?? currentUser?.uid,
    );
  }
}

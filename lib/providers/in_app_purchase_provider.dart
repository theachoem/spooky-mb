import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:spooky/core/api/cloud_firestore/purchased_histories_database.dart';
import 'package:spooky/core/api/cloud_firestore/users_firestore_database.dart';
import 'package:spooky/core/models/product_list_model.dart';
import 'package:spooky/core/models/purchased_info_model.dart';
import 'package:spooky/core/storages/local_storages/purchased_add_on_storage.dart';
import 'package:spooky/core/types/product_as_type.dart';
import 'package:spooky/utils/mixins/schedule_mixin.dart';

class InAppPurchaseProvider extends ChangeNotifier with ScheduleMixin {
  List<String>? purchases;

  bool purchased(ProductAsType type) {
    return purchases?.contains(type.productId) == true;
  }

  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late final ValueNotifier<List<PurchaseDetails>> purchaseNotifier;
  late final ValueNotifier<Map<String, List<MessageModel>>> messageNotifier;
  List<ProductDetails> productDetails = [];

  late final List<String> nonConsumableIds;
  late final List<String> consumableIds;
  Set<String> get productIds => <String>{...nonConsumableIds, ...consumableIds};
  User? get currentUser => FirebaseAuth.instance.currentUser;

  void setMessage({
    required String productId,
    required String message,
    required bool isError,
    required PurchaseStatus status,
    Duration duration = const Duration(seconds: 5),
  }) {
    _setMessage(productId, message, status, isError, false);
    Future.delayed(duration).then((value) {
      _setMessage(productId, message, status, isError, true);
    });
  }

  void _setMessage(
    String productId,
    String message,
    PurchaseStatus status,
    bool isError,
    bool remove,
  ) {
    Map<String, List<MessageModel>> messages = {...messageNotifier.value};
    List<MessageModel> messagesPerId = messages[productId] ?? [];

    if (remove) {
      for (int i = 0; i < messagesPerId.length; i++) {
        if (messagesPerId[i].message == message) {
          messagesPerId[i] = messagesPerId[i].removeMessage();
          break;
        }
      }
    } else {
      messagesPerId.add(MessageModel(status, isError, message));
    }

    messages[productId] = messagesPerId;
    messageNotifier.value = messages;
  }

  InAppPurchaseProvider() {
    purchaseNotifier = ValueNotifier([]);
    messageNotifier = ValueNotifier({});

    inAppPurchase.isAvailable().then((available) {
      if (!available) return;
      inAppPurchase.purchaseStream.listen(listener);
    });

    // get non & consumable with model
    ProductListModel list = ProductListModel.getter();
    nonConsumableIds = list.products.where((e) => !e.consumable).map((e) => e.type.productId).toList();
    consumableIds = list.products.where((e) => e.consumable).map((e) => e.type.productId).toList();
  }

  @override
  void dispose() {
    messageNotifier.dispose();
    purchaseNotifier.dispose();
    super.dispose();
  }

  Future<void> loadPurchasedProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      PurchasedAddOnStorage storage = PurchasedAddOnStorage();
      try {
        UsersFirestoreDatabase database = UsersFirestoreDatabase();
        List<String> purchasesFromAPI = await database.fetchPurchasedProducts(user.uid);
        storage.writeList(purchasesFromAPI);
        purchases = purchasesFromAPI;
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
          String? error = await verifyPurchase(purchaseDetails.status, purchaseDetails);
          if (error == null) {
            await deliverProduct(purchaseDetails);
          } else {
            setMessage(
              productId: purchaseDetails.productID,
              message: error,
              isError: true,
              status: purchaseDetails.status,
            );
          }
          break;
        case PurchaseStatus.pending:
          setMessage(
            productId: purchaseDetails.productID,
            message: 'Pending',
            isError: false,
            status: purchaseDetails.status,
          );
          break;
        case PurchaseStatus.error:
          IAPError? error = purchaseDetails.error;
          if (error != null) {
            setMessage(
              productId: purchaseDetails.productID,
              message: error.message,
              isError: true,
              status: purchaseDetails.status,
            );
          }
          break;
        case PurchaseStatus.canceled:
          setMessage(
            productId: purchaseDetails.productID,
            message: 'Canceled',
            isError: true,
            status: purchaseDetails.status,
          );
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
        buildPurchaedDetail(purchaseDetails, currentUser!),
      );
      await loadPurchasedProducts();
    }
  }

  Future<String?> verifyPurchase(PurchaseStatus status, PurchaseDetails purchaseDetails) async {
    String? purchaseID = purchaseDetails.purchaseID;
    String? uid = currentUser?.uid;
    if (purchaseID == null || uid == null) return "purchaseID || uid null";

    PurchasedInfoModel? result = await PurchaseHistoriesDatabase().get(purchaseID);
    switch (status) {
      case PurchaseStatus.restored:
        bool validated = result == null || result.uid == uid;
        if (validated) {
          PurchaseHistoriesDatabase().addProduct(buildPurchaedDetail(purchaseDetails, currentUser!));
        } else {
          return "User doesn't match with previous purchase";
        }
        break;
      case PurchaseStatus.purchased:
        bool purchasedOnce = result?.purchaseId != null;
        if (!purchasedOnce) {
          PurchaseHistoriesDatabase().addProduct(buildPurchaedDetail(purchaseDetails, currentUser!));
        } else {
          return "Already purchased";
        }
        break;
      case PurchaseStatus.pending:
      case PurchaseStatus.error:
      case PurchaseStatus.canceled:
        break;
    }

    return null;
  }

  PurchasedInfoModel buildPurchaedDetail(PurchaseDetails purchaseDetails, User user) {
    return PurchasedInfoModel(
      purchaseDetails.purchaseID,
      purchaseDetails.productID,
      purchaseDetails.transactionDate,
      user.uid,
      user.providerData.map((e) => e.email ?? e.phoneNumber ?? e.uid ?? user.uid).toSet().toList(),
    );
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

  bool get restorable {
    List<String> cp1 = [...purchases ?? []]
      ..sort()
      ..removeWhere((e) => !productIds.contains(e));
    List<String> cp2 = [...productDetails.map((e) => e.id)]
      ..sort()
      ..removeWhere((e) => !productIds.contains(e));
    return cp1.join(",") != cp2.join(",");
  }

  Future<void> restore() async {
    cacheUid = currentUser?.uid;
    if (restorable && cacheUid != null) {
      return inAppPurchase.restorePurchases(
        applicationUserName: cacheUid,
      );
    }
  }
}

class MessageModel {
  final PurchaseStatus status;
  final String? message;
  final bool isError;

  MessageModel(
    this.status,
    this.isError,
    this.message,
  );

  MessageModel removeMessage() {
    return MessageModel(status, isError, null);
  }
}

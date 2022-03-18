import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:spooky/core/storages/local_storages/nickname_storage.dart';

class GooglePayProvider extends ChangeNotifier {
  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  late final ValueNotifier<List<PurchaseDetails>> purchaseNotifier;
  List<ProductDetails> productDetails = [];

  final List<String> nonConsumableIds = ['font_book'];
  final List<String> consumableIds = [];
  Set<String> get productIds => <String>{...nonConsumableIds, ...consumableIds};

  GooglePayProvider() {
    purchaseNotifier = ValueNotifier([]);
    inAppPurchase.isAvailable().then((available) {
      if (!available) return;
      inAppPurchase.purchaseStream.listen(listener);
    });
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
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            // TODO: handle in valid
          }
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

  // TODO: Call backend & fetch data from backend
  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {}

  // TODO: verify a purchase before delivering the product.
  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  Future<void> buyProduct(ProductDetails productDetails) async {
    PurchaseParam? purchaseParam;

    if (Platform.isAndroid) {
      purchaseParam = GooglePlayPurchaseParam(
        productDetails: productDetails,
        applicationUserName: await NicknameStorage().read() ?? "Unknown",
      );
    } else if (Platform.isIOS) {
      purchaseParam = PurchaseParam(productDetails: productDetails);
    }

    if (purchaseParam != null) {
      if (consumableIds.contains(productDetails.id)) {
        await inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      } else if (nonConsumableIds.contains(productDetails.id)) {
        await inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    }
  }
}

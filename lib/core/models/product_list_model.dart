import 'package:flutter/material.dart';
import 'package:spooky/core/models/product_model.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/types/product_as_type.dart';

class ProductListModel {
  final List<ProductModel> products;
  ProductListModel(this.products);

  factory ProductListModel.getter([BuildContext? context]) {
    return ProductListModel([
      ProductModel(
        type: ProductAsType.fontBook,
        title: "Font Book",
        description: "Access 1300+ fonts!",
        consumable: false,
        icon: Icons.font_download,
        price: "0.99\$",
        onTryPressed: () {
          if (context == null) return;
          Navigator.of(context).pushNamed(SpRouter.fontManager.path);
        },
      ),
      ProductModel(
        type: ProductAsType.relexSound,
        title: "Relax Sound",
        description: "Listen to music while you're writing",
        consumable: false,
        icon: Icons.music_note,
        price: "0.99\$",
        onTryPressed: () {
          if (context == null) return;
          Navigator.of(context).pushNamed(SpRouter.soundList.path);
        },
      ),
    ]);
  }
}

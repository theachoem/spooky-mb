import 'package:flutter/material.dart';
import 'package:spooky/core/models/product_model.dart';
import 'package:spooky/core/routes/sp_router.dart';

class ProductListModel {
  final List<ProductModel> products;
  ProductListModel(this.products);

  factory ProductListModel.getter(BuildContext context) {
    return ProductListModel([
      ProductModel(
        productId: "font_book",
        title: "Font Book",
        description: "Access 1300+ fonts!",
        consumable: false,
        icon: Icons.font_download,
        price: "0.99\$",
        onTryPressed: () {
          Navigator.of(context).pushNamed(SpRouter.fontManager.path);
        },
      ),
      ProductModel(
        productId: "music_player",
        title: "Music Player",
        description: "Listen to music while you're writing",
        consumable: false,
        icon: Icons.music_note,
        price: "0.99\$",
        onTryPressed: () {
          Navigator.of(context).pushNamed(SpRouter.soundList.path);
        },
      ),
    ]);
  }
}

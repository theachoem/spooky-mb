import 'package:flutter/material.dart';
import 'package:spooky/core/models/product_model.dart';

class ProductListModel {
  final List<ProductModel> products;
  ProductListModel(this.products);

  factory ProductListModel.getter() {
    return ProductListModel([
      ProductModel(
        productId: "font_book",
        title: "Font Book",
        description: "Access 1300+ fonts!",
        consumable: false,
        icon: Icons.font_download,
        price: "0.99\$",
      ),
      ProductModel(
        productId: "music_player",
        title: "Music Plater",
        description: "Play music while you writing",
        consumable: false,
        icon: Icons.music_note,
        price: "0.99\$",
      ),
    ]);
  }
}

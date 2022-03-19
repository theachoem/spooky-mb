import 'package:flutter/material.dart';

class ProductModel {
  final String productId;
  final String title;
  final String description;
  final bool consumable;
  final IconData icon;
  final String price;
  final void Function() onTryPressed;

  ProductModel({
    required this.productId,
    required this.title,
    required this.description,
    required this.consumable,
    required this.icon,
    required this.price,
    required this.onTryPressed,
  });
}

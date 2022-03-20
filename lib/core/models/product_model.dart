import 'package:flutter/material.dart';
import 'package:spooky/core/types/product_as_type.dart';
export 'package:spooky/utils/extensions/product_as_type_extension.dart';

class ProductModel {
  final ProductAsType type;
  final String title;
  final String description;
  final bool consumable;
  final IconData icon;
  final String price;
  final void Function() onTryPressed;

  ProductModel({
    required this.type,
    required this.title,
    required this.description,
    required this.consumable,
    required this.icon,
    required this.price,
    required this.onTryPressed,
  });
}

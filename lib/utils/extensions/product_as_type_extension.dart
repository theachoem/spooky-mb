import 'package:spooky/core/types/product_as_type.dart';

extension ProductAsTypeExtension on ProductAsType {
  String get productId {
    switch (this) {
      case ProductAsType.relexSound:
        return "relax_sound";
      case ProductAsType.fontBook:
        return "font_book";
    }
  }
}

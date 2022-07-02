import 'dart:io';

import 'package:spooky/core/types/product_as_type.dart';

extension ProductAsTypeExtension on ProductAsType {
  String get productId {
    switch (this) {
      case ProductAsType.relexSound:
        if (Platform.isIOS || Platform.isMacOS) {
          return "relax_sound_v2";
        } else {
          return "relax_sound";
        }
    }
  }

  // SOME deleted by mistake, so we create new.
  // Here is its old version ID
  String get oldProductId {
    switch (this) {
      case ProductAsType.relexSound:
        if (Platform.isIOS) {
          return "relax_sound";
        } else {
          return "relax_sound";
        }
    }
  }
}

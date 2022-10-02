import 'package:flutter_quill/flutter_quill.dart';
import 'package:string_validator/string_validator.dart';

// ref: flutter_quill_extensions/embeds/utils.dart
bool isImageBase64(String imageUrl) {
  return !imageUrl.startsWith('http') && isBase64(imageUrl);
}

// ref: flutter_quill_extensions/embeds/widgets/image.dart:20
String getImageStyleString(QuillController controller) {
  final String? s = controller
      .getAllSelectionStyles()
      .firstWhere((s) => s.attributes.containsKey(Attribute.style.key), orElse: () => Style())
      .attributes[Attribute.style.key]
      ?.value;
  return s ?? '';
}

// ref: flutter_quill_extensions/embeds/widgets/image.dart: 47
String standardizeImageUrl(String url) {
  if (url.contains('base64')) {
    return url.split(',')[1];
  }
  return url;
}

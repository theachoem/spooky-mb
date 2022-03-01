import 'package:google_fonts/google_fonts.dart';
import 'package:spooky/core/base/base_view_model.dart';

class FontManagerViewModel extends BaseViewModel {
  late final fonts = GoogleFonts.asMap().entries.toList();
  bool preview = false;

  Future<void> togglePreview() async {
    preview = !preview;
    notifyListeners();
  }
}

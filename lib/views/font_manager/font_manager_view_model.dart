import 'package:google_fonts/google_fonts.dart';
import 'package:spooky/core/base/base_view_model.dart';

class FontManagerViewModel extends BaseViewModel {
  GoogleFonts googleFonts = GoogleFonts();
  FontManagerViewModel() {
    load();
  }

  Future<void> load() async {
    GoogleFonts.getFont("");
  }
}

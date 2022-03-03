import 'package:google_sign_in/google_sign_in.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';
import 'package:spooky/core/base/base_view_model.dart';

class CloudStorageViewModel extends BaseViewModel {
  final GoogleAuthService googleAuth = GoogleAuthService.instance;
  GoogleSignInAccount? googleUser;

  CloudStorageViewModel() {
    load();
  }

  Future<void> load() async {
    await googleAuth.googleSignIn.isSignedIn().then((signedIn) async {
      if (signedIn) {
        await googleAuth.signInSilently();
        googleUser = googleAuth.googleSignIn.currentUser;
        notifyListeners();
      }
    });
  }

  Future<void> signInWithGoogle() async {
    await googleAuth.signIn();
    load();
  }
}

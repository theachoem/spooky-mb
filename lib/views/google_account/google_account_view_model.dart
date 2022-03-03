import 'package:google_sign_in/google_sign_in.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';
import 'package:spooky/core/api/services/google_drive_service.dart';
import 'package:spooky/core/base/base_view_model.dart';

class GoogleAccountViewModel extends BaseViewModel {
  GoogleSignInAccount? get currentUser => service.googleSignIn.currentUser;

  final GoogleAuthService service = GoogleAuthService.instance;
  final GoogleDriveService driveService = GoogleDriveService();

  GoogleAccountViewModel() {
    load();
  }

  Future<void> load() async {
    bool signIn = await service.googleSignIn.isSignedIn();
    if (signIn) {
      await service.signInSilently();
      notifyListeners();
    }
  }

  Future<void> signIn() async {
    bool signIn = await service.googleSignIn.isSignedIn();
    if (!signIn) {
      await service.signIn();
      notifyListeners();
    }
  }
}

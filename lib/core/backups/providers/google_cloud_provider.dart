import 'package:google_sign_in/google_sign_in.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';
import 'package:spooky/core/backups/providers/base_cloud_provider.dart';
import 'package:spooky/core/storages/local_storages/spooky_drive_folder_id_storage.dart';

class GoogleCloudProvider extends BaseCloudProvider {
  final GoogleAuthService googleAuth = GoogleAuthService.instance;
  GoogleSignInAccount? googleUser;
  String? driveFolderId;

  GoogleCloudProvider() {
    load();
  }

  Future<void> load() async {
    driveFolderId = await SpookyDriveFolderStorageIdStorage().read();
    await loadAuthentication();
    notifyListeners();
  }

  Future<void> loadAuthentication() async {
    await googleAuth.googleSignIn.isSignedIn().then((signedIn) async {
      if (signedIn) {
        await googleAuth.signInSilently();
        googleUser = googleAuth.googleSignIn.currentUser;
      } else {
        googleUser = null;
      }
    });
  }

  @override
  bool get isSignedIn => googleUser != null;

  @override
  Future<void> signIn() async {
    await googleAuth.signIn();
    load();
  }

  @override
  Future<void> signOut() async {
    await googleAuth.signOut();
    await load();
  }

  @override
  String get title => googleUser?.displayName ?? "Google Drive";

  @override
  String? get subtitle => googleUser?.email;
}

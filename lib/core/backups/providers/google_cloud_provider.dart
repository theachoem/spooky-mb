import 'package:google_sign_in/google_sign_in.dart';
import 'package:spooky/core/external_apis/authentication/google_auth_service.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/destinations/gdrive_backup_destination.dart';
import 'package:spooky/core/backups/providers/base_cloud_provider.dart';
import 'package:spooky/core/storages/local_storages/spooky_drive_folder_id_storage.dart';

class GoogleCloudProvider extends BaseCloudProvider {
  GoogleCloudProvider._();
  static final GoogleCloudProvider instance = GoogleCloudProvider._();

  @override
  BaseBackupDestination<BaseCloudProvider> get destination => GDriveBackupDestination();

  final GoogleAuthService googleAuth = GoogleAuthService.instance;
  GoogleSignInAccount? googleUser;
  String? driveFolderId;

  @override
  String get cloudName => "Google Drive";

  @override
  String? get name => googleUser?.displayName;

  @override
  String? get username => googleUser?.email;

  @override
  bool get isSignedIn => googleUser != null;

  @override
  Future<void> load([bool reload = true]) async {
    driveFolderId = await SpookyDriveFolderStorageIdStorage().read();
    return await super.load(reload);
  }

  @override
  Future<void> loadAuthentication() async {
    bool signedIn = await googleAuth.googleSignIn.isSignedIn();

    if (signedIn) {
      await googleAuth.signInSilently();
      googleUser = googleAuth.googleSignIn.currentUser;
    } else {
      googleUser = null;
    }

    notifyListeners();
  }

  @override
  Future<void> signIn() async {
    await googleAuth.signIn();
    await load();
    return super.signIn();
  }

  @override
  Future<void> signOut() async {
    await googleAuth.signOut();
    await load();
  }
}

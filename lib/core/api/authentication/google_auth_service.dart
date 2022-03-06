import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:spooky/core/api/authentication/google_auth_client.dart';
import 'package:spooky/core/storages/local_storages/google_auth_headers_storage.dart';

class GoogleAuthService {
  static GoogleAuthService get instance => GoogleAuthService._();
  GoogleAuthService._();

  final GoogleSignIn googleSignIn = GoogleSignIn.standard(scopes: [
    drive.DriveApi.driveAppdataScope,
    drive.DriveApi.driveFileScope,
  ]);

  final GoogleAuthHeadersStorage storage = GoogleAuthHeadersStorage();

  Future<GoogleAuthClient?> get client async {
    return storage.readMap().then((value) {
      return value != null ? GoogleAuthClient(value) : null;
    });
  }

  Future<void> writeToStorage(GoogleSignInAccount account) async {
    Map<String, String> map = await account.authHeaders;
    await storage.writeMap(map);
  }

  Future<void> signInSilently({bool reAuthenticate = false}) async {
    GoogleSignInAccount? account = await googleSignIn.signInSilently(reAuthenticate: reAuthenticate);
    if (account != null) {
      await writeToStorage(account);
    } else {
      await signIn();
    }
  }

  Future<void> signIn() async {
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account != null) {
      await writeToStorage(account);
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await storage.remove();
  }
}

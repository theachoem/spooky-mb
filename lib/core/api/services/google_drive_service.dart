import 'package:googleapis/drive/v3.dart';
import 'package:spooky/core/api/authentication/google_auth_client.dart';
import 'package:spooky/core/api/authentication/google_auth_service.dart';

class GoogleDriveService {
  Future<DriveApi?> get driveClient async {
    GoogleAuthClient? client = await GoogleAuthService.instance.client;
    if (client != null) return DriveApi(client);
    return null;
  }

  fetchAll() async {
    DriveApi? driveApi = await driveClient;
    if (driveApi != null) {
      FileList fileList = await driveApi.files.list();
      print(fileList.files?.map((e) => e.originalFilename));
    }
  }
}

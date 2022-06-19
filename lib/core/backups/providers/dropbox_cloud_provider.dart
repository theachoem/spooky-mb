import 'package:spooky/core/backups/providers/base_cloud_provider.dart';

class DropboxCloudProvider extends BaseCloudProvider {
  @override
  bool get isSignedIn => false;

  @override
  Future<void> signIn() {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }

  @override
  String? get subtitle => null;

  @override
  String get title => "Dropbox";
}

// ignore_for_file: must_call_super

import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/backups/destinations/dropbox_backup_destination.dart';
import 'package:spooky/core/backups/providers/base_cloud_provider.dart';

class DropboxCloudProvider extends BaseCloudProvider {
  @override
  BaseBackupDestination<BaseCloudProvider> get destination => DropBoxBackupDestination();

  @override
  bool get isSignedIn => false;

  @override
  bool get released => false;

  @override
  Future<void> signIn() {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    throw UnimplementedError();
  }

  @override
  String get cloudName => "Dropbox";

  @override
  String? get name => null;

  @override
  String? get username => null;

  @override
  Future<void> loadAuthentication() async {}
}

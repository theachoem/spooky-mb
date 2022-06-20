import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/core/base/base_view_model.dart';

class BackupsDetailsViewModel extends BaseViewModel {
  final BaseBackupDestination destination;
  BackupsDetailsViewModel(this.destination);
}

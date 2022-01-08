import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

@module
abstract class ThirdPartyServicesModule {
  @singleton
  NavigationService get navigationService;
  @singleton
  DialogService get dialogService;
  @singleton
  SnackbarService get snackbarService;
}

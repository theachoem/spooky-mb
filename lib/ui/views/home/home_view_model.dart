import 'package:stacked/stacked.dart';

class HomeViewModel extends IndexTrackingViewModel {
  final void Function(int index) onTabChange;
  HomeViewModel(this.onTabChange);

  // HomeViewModel() {
  //   TabController tabController = TabController(length: length, vsync: this.);
  // }

}

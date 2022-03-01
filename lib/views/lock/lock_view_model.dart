import 'package:spooky/views/lock/types/lock_flow_type.dart';
import 'package:spooky/core/base/base_view_model.dart';

class LockViewModel extends BaseViewModel {
  final LockFlowType flowType;

  LockViewModel(this.flowType);
}

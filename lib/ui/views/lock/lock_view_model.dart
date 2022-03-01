import 'package:spooky/ui/views/lock/types/lock_flow_type.dart';
import 'package:flutter/material.dart';

class LockViewModel extends ChangeNotifier {
  final LockFlowType flowType;

  LockViewModel(this.flowType);
}

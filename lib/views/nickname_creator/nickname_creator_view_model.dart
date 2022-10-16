import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:spooky/core/base/base_view_model.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class NicknameCreatorViewModel extends BaseViewModel {
  late final ValueNotifier<String> nicknameNotifier;
  late final Completer<int> completer;

  NicknameCreatorViewModel() {
    nicknameNotifier = ValueNotifier("");
    completer = Completer();
    Future.delayed(ConfigConstant.fadeDuration).then((value) {
      completer.complete(1);
    });
  }

  @override
  void dispose() {
    nicknameNotifier.dispose();
    super.dispose();
  }
}

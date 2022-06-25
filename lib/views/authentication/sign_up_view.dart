import 'package:flutter/material.dart';
import 'package:spooky/views/authentication/base/base_auth_view.dart';

class SignUpView extends BaseAuthView {
  const SignUpView({Key? key}) : super(key: key);

  @override
  AuthFlowType get flowType => AuthFlowType.signUp;
}

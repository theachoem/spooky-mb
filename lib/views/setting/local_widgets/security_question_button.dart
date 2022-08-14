import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/core/security/helpers/security_question_list_model.dart';
import 'package:spooky/core/security/helpers/security_question_model.dart';
import 'package:spooky/core/security/security_service.dart';
import 'package:spooky/core/storages/local_storages/security/security_questions_storage.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/views/lock/types/lock_flow_type.dart';
import 'package:spooky/widgets/sp_icon_button.dart';

class SecurityQuestionButton extends StatefulWidget {
  const SecurityQuestionButton({Key? key}) : super(key: key);

  @override
  State<SecurityQuestionButton> createState() => _SecurityQuestionButtonState();
}

class _SecurityQuestionButtonState extends State<SecurityQuestionButton> {
  final SecurityQuestionsStorage storage = SecurityQuestionsStorage();
  bool hasSecurityQuestion = true;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    bool locked = await SecurityService().lockInfo.getLock() != null;
    if (locked) {
      SecurityQuestionListModel? questions = await storage.readObject();
      List<SecurityQuestionModel> items = questions?.items ?? [];
      items = items.where((element) => element.answer != null).toList();
      if (hasSecurityQuestion != items.isNotEmpty) {
        setState(() {
          hasSecurityQuestion = items.isNotEmpty;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasSecurityQuestion) return const SizedBox.shrink();
    return SpIconButton(
      icon: Icon(
        Icons.warning,
        color: M3Color.dayColorsOf(context)[1],
      ),
      onPressed: () async {
        showOkAlertDialog(
          context: context,
          title: tr("alert.action_required.title"),
          message: tr("alert.action_required.set_security_question"),
        ).then((value) {
          if (value == OkCancelResult.ok) {
            navigate(context);
          }
        });
      },
    );
  }

  Future<void> navigate(BuildContext context) async {
    bool authenticated = await SecurityService().showLockIfHas(
      context,
      flowType: LockFlowType.middleware,
    );
    if (authenticated) {
      // ignore: use_build_context_synchronously
      await Navigator.of(context).pushNamed(SpRouter.security.path);
      initialize();
    }
  }
}

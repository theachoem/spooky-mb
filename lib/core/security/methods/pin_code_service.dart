part of security_service;

class _PinCodeService extends _BaseLockService<_PinCodeOptions> {
  final _SecurityInformations info;
  _PinCodeService(this.info);

  @override
  Future<bool> unlock(_PinCodeOptions option) async {
    assert(option.object != null);

    bool authenticated = await _confirmOwnership(
      context: option.context,
      secret: option.object!.secret,
      canCancel: option.canCancel,
    );

    return option.next(authenticated);
  }

  @override
  Future<bool> set(_PinCodeOptions option) async {
    String? matchedSecret = await enhancedScreenLock<String>(
      digits: 4,
      context: option.context,
      correctString: '',
      title: const Text('Please enter new passcode'),
      confirmation: true,
      didConfirmed: (matchedSecret) {
        Navigator.of(option.context).pop(matchedSecret);
      },
    );
    if (matchedSecret != null) {
      info._storage.setLock(option.lockType, matchedSecret);
      return option.next(true);
    } else {
      return option.next(false);
    }
  }

  @override
  Future<bool> remove(_PinCodeOptions option) async {
    assert(option.object != null);
    bool authenticated = await _confirmOwnership(
      context: option.context,
      secret: option.object!.secret,
      canCancel: option.canCancel,
    );
    if (authenticated) await info.clear();
    return option.next(authenticated);
  }

  Future<bool> _confirmOwnership({
    required BuildContext context,
    required String secret,
    bool canCancel = false,
  }) async {
    bool? authenticated = await enhancedScreenLock<bool>(
      context: context,
      correctString: secret,
      canCancel: canCancel,
      footer: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: SpButton(
          backgroundColor: M3Color.of(context).readOnly.surface1,
          foregroundColor: M3Color.of(context).onSurface,
          label: "No longer access?",
          onTap: () => clearLockWithSecurityQuestions(context),
        ),
      ),
      didUnlocked: () {
        Navigator.of(context).pop(true);
      },
    );
    return authenticated == true;
  }

  Future<void> clearLockWithSecurityQuestions(BuildContext context) async {
    SecurityQuestionListModel? result = await SecurityQuestionsStorage().readObject();
    List<SecurityQuestionModel> items = result?.items ?? [];
    items = items.where((element) => element.answer != null).toList();

    if (items.isEmpty) {
      MessengerService.instance.showSnackBar(
        "No security question!",
        success: false,
      );
      return;
    }

    String? questionKey = await showModalActionSheet(
      context: context,
      title: "Answer one of these questions to unlock",
      actions: items.map((e) {
        return SheetAction(label: e.question, key: e.key);
      }).toList(),
    );

    if (questionKey == null) return;
    SecurityQuestionModel question = items.where((element) => questionKey == element.key).first;
    List<String>? answers = await showTextInputDialog(
      context: context,
      title: question.question,
      textFields: const [
        DialogTextField(),
      ],
    );

    if (answers?.isEmpty == true) return;
    String answer = answers![0];
    double similarity = answer.toLowerCase().similarityTo(question.answer?.toLowerCase());

    if (similarity > 0.8) {
      info.clear();
      MessengerService.instance.showSnackBar(
        "Matched ${(similarity * 100).toStringAsFixed(2)}%. Lock cleared!",
        success: true,
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      MessengerService.instance.showSnackBar(
        "Incorrect answer",
        success: false,
      );
    }
  }
}

part of security_view;

class _SecurityMobile extends StatefulWidget {
  final SecurityViewModel viewModel;
  const _SecurityMobile(this.viewModel);

  @override
  State<_SecurityMobile> createState() => _SecurityMobileState();
}

class _SecurityMobileState extends State<_SecurityMobile> with ScaffoldEndDrawableMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: endDrawerScaffoldKey,
      endDrawer: buildEndDrawer(context),
      appBar: MorphingAppBar(
        automaticallyImplyLeading: false,
        actions: const [SizedBox.shrink()],
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
        title: const SpAppBarTitle(fallbackRouter: SpRouter.security),
      ),
      body: ValueListenableBuilder<LockType?>(
        valueListenable: widget.viewModel.lockedTypeNotifier,
        builder: (context, lockedType, child) {
          return ListView(
            children: SpSectionsTiles.divide(
              context: context,
              sections: [
                buildLockMethods(lockedType, context),
                if (lockedType != null) buildOtherSetting(context),
              ],
            ),
          );
        },
      ),
    );
  }

  SpSectionContents buildOtherSetting(BuildContext context) {
    return SpSectionContents(
      headline: tr("section.settings"),
      tiles: [
        ValueListenableBuilder<int>(
          valueListenable: widget.viewModel.lockLifeCircleDurationNotifier,
          builder: (context, seconds, child) {
            return Tooltip(
              message: tr("msg.lock_life_circle", args: [seconds.toString()]),
              child: ListTile(
                leading: const SizedBox(height: 40, child: Icon(Icons.update_sharp)),
                title: Text(tr("tile.lock_life_circle.title")),
                subtitle: Text(tr("tile.lock_life_circle.subtitle", args: [seconds.toString()])),
                onTap: () async {
                  DateTime? date = await SpDatePicker.showSecondsPicker(context, seconds);
                  if (date == null) return;
                  if (date.second > 10) {
                    widget.viewModel.setLockLifeCircleDuration(date.second);
                  } else {
                    MessengerService.instance.showSnackBar(tr("msg.lock_life_circle_minimum"));
                    widget.viewModel.setLockLifeCircleDuration(10);
                  }
                },
              ),
            );
          },
        ),
        ValueListenableBuilder<SecurityQuestionListModel?>(
          valueListenable: widget.viewModel.securityQuestionNotifier,
          builder: (context, questions, child) {
            int questionCount = questions?.items?.where((e) => e.answer != null).length ?? 0;
            return FutureBuilder(
              future: Future.delayed(ConfigConstant.duration * 1.5).then((value) => 1),
              builder: (context, snapshot) {
                bool shouldUpdate = questionCount > 0 || snapshot.hasData;
                return AnimatedContainer(
                  duration: ConfigConstant.duration * 2,
                  curve: Curves.ease,
                  color: shouldUpdate ? M3Color.of(context).background : M3Color.of(context).readOnly.surface1,
                  child: ListTile(
                    leading: const SizedBox(height: 40, child: Icon(CommunityMaterialIcons.lock_question)),
                    title: Text(tr("tile.security_question.title")),
                    subtitle: Text(plural("plural.question_added", questionCount)),
                    onTap: () {
                      openEndDrawer();
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  SpSectionContents buildLockMethods(LockType? lockedType, BuildContext context) {
    return SpSectionContents(
      headline: tr("section.lock_method"),
      tiles: [
        // ListTile(
        //   leading: SizedBox(height: 40, child: Icon(Icons.password)),
        //   trailing: Radio(value: LockType.password, groupValue: lockedType, onChanged: (value) {}),
        //   title: Text("Password"),
        //   onTap: () {
        //     Navigator.of(context).pushNamed(
        //       SpRouteConfig.lock,
        //       arguments: LockArgs(
        //         flowType: LockFlowType.setPassword,
        //       ),
        //     );
        //   },
        // ),
        ListTile(
          leading: const SizedBox(height: 40, child: Icon(Icons.pin)),
          trailing: Radio(value: LockType.pin, groupValue: lockedType, onChanged: (value) {}),
          title: Text(tr("tile.pin_code.title")),
          subtitle: Text(tr("tile.pin_code.subtitle")),
          onTap: () => onPinCodePressed(context),
        ),
        if (widget.viewModel.service.lockInfo.hasLocalAuth)
          ListTile(
            leading: const SizedBox(height: 40, child: Icon(Icons.fingerprint)),
            trailing: Radio(value: LockType.biometric, groupValue: lockedType, onChanged: (value) {}),
            title: Text(tr("tile.biometric.title")),
            subtitle: Text(tr("tile.biometric.subtitle")),
            onTap: () => onBiometricsPressed(context),
          ),
      ],
    );
  }

  Future<void> onPressed({
    required LockType type,
    required BuildContext context,
    required String hasLockTitle,
    required String noLockTitle,
    required String removeLockTitle,
    required Future<void> Function() onSetPressed,
    required Future<void> Function() onRemovePressed,
  }) async {
    bool hasLock = widget.viewModel.lockedTypeNotifier.value == type;

    SheetAction<String>? setOption;
    SheetAction<String>? removeOption;

    setOption = SheetAction(
      label: hasLock ? hasLockTitle : noLockTitle,
      key: "add_update",
      icon: hasLock ? Icons.update : Icons.add,
    );

    removeOption = SheetAction(
      label: removeLockTitle,
      key: "remove",
      isDestructiveAction: true,
      icon: Icons.remove,
    );

    // should display remove
    if (!hasLock) removeOption = null;

    // should display set or update
    switch (type) {
      case LockType.pin:
        break;
      case LockType.password:
        break;
      case LockType.biometric:
        if (hasLock) setOption = null;
        break;
    }

    List<SheetAction<String>> actions = [
      if (setOption != null) setOption,
      if (removeOption != null) removeOption,
    ];

    if (actions.isEmpty) return;
    String? value = await showModalActionSheet(
      context: context,
      actions: actions,
    );

    switch (value) {
      case "add_update":
        await onSetPressed();
        await widget.viewModel.load();
        break;
      case "remove":
        await onRemovePressed();
        await widget.viewModel.load();
        break;
      default:
    }
  }

  Future<void> onPinCodePressed(BuildContext context) async {
    return onPressed(
      type: LockType.pin,
      context: context,
      hasLockTitle: tr("security.pin_code.update"),
      noLockTitle: tr("security.pin_code.add"),
      removeLockTitle: tr("security.pin_code.remove"),
      onSetPressed: () async {
        await widget.viewModel.service.set(context: context, type: LockType.pin);
        await widget.viewModel.load();
      },
      onRemovePressed: () async {
        await widget.viewModel.service.remove(context: context, type: LockType.pin);
        await widget.viewModel.load();
      },
    );
  }

  Future<void> onBiometricsPressed(BuildContext context) async {
    return onPressed(
      type: LockType.biometric,
      context: context,
      hasLockTitle: tr("security.biometrics.update"),
      noLockTitle: tr("security.biometrics.add"),
      removeLockTitle: tr("security.biometrics.remove"),
      onSetPressed: () async {
        await widget.viewModel.service.set(context: context, type: LockType.biometric);
        await widget.viewModel.load();
      },
      onRemovePressed: () async {
        await widget.viewModel.service.remove(context: context, type: LockType.biometric);
        await widget.viewModel.load();
      },
    );
  }

  @override
  Widget buildEndDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: SpSectionsTiles.divide(
          context: context,
          sections: [
            SpSectionContents(
              headline: tr("section.questions"),
              tiles: [
                ConfigConstant.sizedBoxH2,
                const Divider(height: 1),
                buildQuestionList(),
                buildAddQuestionTile(context),
                const Divider(height: 1),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildAddQuestionTile(BuildContext context) {
    return ListTile(
      leading: const SizedBox(height: 44, child: Icon(Icons.add)),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ConfigConstant.margin2,
        vertical: ConfigConstant.margin0,
      ),
      title: Text(tr("tile.add_your_own_questions")),
      onTap: () async {
        if (endDrawerScaffoldKey.currentState?.isEndDrawerOpen == true) {
          endDrawerScaffoldKey.currentState?.closeEndDrawer();
        }

        List<String>? qa = await showTextInputDialog(
          context: context,
          title: tr("alert.new_question_answer.title"),
          okLabel: tr("button.save"),
          barrierDismissible: false,
          textFields: [
            DialogTextField(
              hintText: tr("field.question.hint_text"),
              validator: (value) {
                if ((value?.trim() ?? "").isEmpty) {
                  return tr("field.question.validation");
                }
                return null;
              },
            ),
            DialogTextField(
              hintText: tr("field.answer.hint_text"),
              validator: (value) {
                if ((value?.trim() ?? "").isEmpty) {
                  return tr("field.answer.validation");
                }
                return null;
              },
            ),
          ],
        );

        if (qa != null && qa.length == 2) {
          widget.viewModel.setAnswer(SecurityQuestionModel(
            question: qa[0],
            answer: qa[1],
            key: "custom-${DateTime.now().millisecondsSinceEpoch}",
          ));
        }
      },
    );
  }

  Widget buildQuestionList() {
    return ValueListenableBuilder<SecurityQuestionListModel>(
      valueListenable: widget.viewModel.securityQuestionNotifier,
      builder: (context, questions, child) {
        List<SecurityQuestionModel> items = questions.items ?? [];
        return Column(
          children: items.map((e) {
            return Column(
              children: [
                ListTile(
                  trailing: const SizedBox(height: 44, child: Icon(Icons.question_answer)),
                  contentPadding: const EdgeInsets.all(ConfigConstant.margin2),
                  title: Text(e.question),
                  subtitle: Text(e.answer != null ? "*" * e.answer!.length : tr("msg.no_answer_provided")),
                  onTap: () async {
                    if (endDrawerScaffoldKey.currentState?.isEndDrawerOpen == true) {
                      endDrawerScaffoldKey.currentState?.closeEndDrawer();
                    }

                    String? answer = await showTextInputDialog(
                      context: context,
                      title: e.question,
                      okLabel: tr("button.save"),
                      barrierDismissible: false,
                      textFields: [
                        DialogTextField(
                          initialText: e.answer,
                          hintText: tr("msg.no_answer_provided"),
                        ),
                      ],
                    ).then((value) {
                      if (value?.isNotEmpty == true) {
                        return value![0];
                      } else {
                        return null;
                      }
                    });

                    if (answer != null) {
                      widget.viewModel.setAnswer(e.copyWith(answer: answer.trim().isEmpty ? null : answer));
                    }
                  },
                ),
                const Divider(height: 1),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

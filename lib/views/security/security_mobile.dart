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
      headline: "Settings",
      tiles: [
        ValueListenableBuilder<SecurityQuestionListModel?>(
          valueListenable: widget.viewModel.securityQuestionNotifier,
          builder: (context, questions, child) {
            int questionCount = questions?.items?.where((e) => e.answer != null).length ?? 0;
            return ListTile(
              leading: const SizedBox(height: 40, child: Icon(CommunityMaterialIcons.lock_question)),
              title: const Text("Security questions"),
              subtitle: Text(
                questionCount > 1
                    ? "$questionCount questions added"
                    : "${questionCount == 0 ? "No" : questionCount} question added",
              ),
              onTap: () {
                openEndDrawer();
              },
            );
          },
        ),
        ValueListenableBuilder<int>(
          valueListenable: widget.viewModel.lockLifeCircleDurationNotifier,
          builder: (context, seconds, child) {
            return Tooltip(
              message: "Lock application when inactive for $seconds seconds",
              child: ListTile(
                leading: const SizedBox(height: 40, child: Icon(Icons.update_sharp)),
                title: const Text("Lock life circle"),
                subtitle: Text("$seconds seconds"),
                onTap: () async {
                  DateTime? date = await SpDatePicker.showSecondsPicker(context, seconds);
                  if (date == null) return;
                  if (date.second > 10) {
                    widget.viewModel.setLockLifeCircleDuration(date.second);
                  } else {
                    MessengerService.instance.showSnackBar("10 seconds minimum");
                    widget.viewModel.setLockLifeCircleDuration(10);
                  }
                },
              ),
            );
          },
        )
      ],
    );
  }

  SpSectionContents buildLockMethods(LockType? lockedType, BuildContext context) {
    return SpSectionContents(
      headline: "Lock Methods",
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
          title: const Text("PIN code"),
          subtitle: const Text("4 digit"),
          onTap: () => onPinCodePressed(context),
        ),
        if (widget.viewModel.service.lockInfo.hasLocalAuth)
          ListTile(
            leading: const SizedBox(height: 40, child: Icon(Icons.fingerprint)),
            trailing: Radio(value: LockType.biometric, groupValue: lockedType, onChanged: (value) {}),
            title: const Text("Biometrics"),
            subtitle: const Text("Unlock app base on biometric"),
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
      hasLockTitle: "Update PIN code",
      noLockTitle: "Add PIN code",
      removeLockTitle: "Remove PIN code",
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
      hasLockTitle: "Update Biometrics",
      noLockTitle: "Add Biometrics",
      removeLockTitle: "Remove Biometrics",
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
              headline: "Questions",
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
      title: const Text("Add your own question"),
      onTap: () async {
        if (endDrawerScaffoldKey.currentState?.isEndDrawerOpen == true) {
          endDrawerScaffoldKey.currentState?.closeEndDrawer();
        }

        List<String>? qa = await showTextInputDialog(
          context: context,
          title: "New Question & Answer",
          okLabel: "Save",
          barrierDismissible: false,
          textFields: [
            DialogTextField(
              hintText: "Question",
              validator: (value) {
                if ((value?.trim() ?? "").isEmpty) {
                  return "Must not empty";
                }
                return null;
              },
            ),
            DialogTextField(
              hintText: "Answer",
              validator: (value) {
                if ((value?.trim() ?? "").isEmpty) {
                  return "Must not empty";
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
                  subtitle: Text(e.answer != null ? "*" * e.answer!.length : "No answer provided"),
                  onTap: () async {
                    if (endDrawerScaffoldKey.currentState?.isEndDrawerOpen == true) {
                      endDrawerScaffoldKey.currentState?.closeEndDrawer();
                    }

                    String? answer = await showTextInputDialog(
                      context: context,
                      title: e.question,
                      okLabel: "Save",
                      barrierDismissible: false,
                      textFields: [
                        DialogTextField(
                          initialText: e.answer,
                          hintText: "No answer provided",
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

part of security_view;

class _SecurityMobile extends StatelessWidget {
  final SecurityViewModel viewModel;
  const _SecurityMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: const SpPopButton(),
        title: const SpAppBarTitle(),
      ),
      body: ValueListenableBuilder<LockType?>(
        valueListenable: viewModel.lockedTypeNotifier,
        builder: (context, lockedType, child) {
          return ListView(
            children: SpSectionsTiles.divide(
              context: context,
              sections: [
                buildLockMethods(lockedType, context),
                if (lockedType != null) buildOtherSetting(),
              ],
            ),
          );
        },
      ),
    );
  }

  SpSectionContents buildOtherSetting() {
    return SpSectionContents(
      headline: "Settings",
      tiles: [
        ValueListenableBuilder<int>(
          valueListenable: viewModel.lockLifeCircleDurationNotifier,
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
                    viewModel.setLockLifeCircleDuration(date.second);
                  } else {
                    MessengerService.instance.showSnackBar("10 seconds minimum");
                    viewModel.setLockLifeCircleDuration(10);
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
        // TODO: Implement set password
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
        if (viewModel.service.lockInfo.hasLocalAuth)
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
    bool hasLock = viewModel.lockedTypeNotifier.value == type;

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
        await viewModel.load();
        break;
      case "remove":
        await onRemovePressed();
        await viewModel.load();
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
        await viewModel.service.set(context: context, type: LockType.pin);
        await viewModel.load();
      },
      onRemovePressed: () async {
        await viewModel.service.remove(context: context, type: LockType.pin);
        await viewModel.load();
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
        await viewModel.service.set(context: context, type: LockType.biometric);
        await viewModel.load();
      },
      onRemovePressed: () async {
        await viewModel.service.remove(context: context, type: LockType.biometric);
        await viewModel.load();
      },
    );
  }
}

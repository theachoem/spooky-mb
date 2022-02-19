part of security_view;

class _SecurityMobile extends StatelessWidget {
  final SecurityViewModel viewModel;
  const _SecurityMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        title: Text(
          "Security",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
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
      headline: "Other Setting",
      tiles: [
        ValueListenableBuilder<int>(
          valueListenable: viewModel.lockLifeCircleDurationNotifier,
          builder: (context, seconds, child) {
            return ListTile(
              leading: SizedBox(height: 40, child: Icon(Icons.update_sharp)),
              title: Text("Lock Life circle"),
              subtitle: Text("$seconds seconds"),
              onTap: () async {
                DateTime? date = await SpDatePicker.showSecondsPicker(context, seconds);
                viewModel.setLockLifeCircleDuration(date?.second);
              },
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
          leading: SizedBox(height: 40, child: Icon(Icons.pin)),
          trailing: Radio(value: LockType.pin, groupValue: lockedType, onChanged: (value) {}),
          title: Text("PIN code"),
          subtitle: Text("4 digit"),
          onTap: () => onPinCodePressed(context),
        ),
        if (viewModel.service.lockInfo.hasLocalAuth)
          ListTile(
            leading: SizedBox(height: 40, child: Icon(Icons.fingerprint)),
            trailing: Radio(value: LockType.biometric, groupValue: lockedType, onChanged: (value) {}),
            title: Text("Biometrics"),
            subtitle: Text("Unlock app base on biometric"),
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
    String? value = await showModalActionSheet(
      context: context,
      actions: [
        SheetAction(
          label: hasLock ? hasLockTitle : noLockTitle,
          key: "add_update",
          icon: hasLock ? Icons.update : Icons.add,
        ),
        if (hasLock)
          SheetAction(
            label: removeLockTitle,
            key: "remove",
            isDestructiveAction: true,
            icon: Icons.remove,
          ),
      ],
    );
    switch (value) {
      case "add_update":
        await onSetPressed();
        viewModel.load();
        break;
      case "remove":
        await onRemovePressed();
        viewModel.load();
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

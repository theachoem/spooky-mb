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
              sections: [buildLockMethods(lockedType, context), if (lockedType != null) buildOtherSetting()],
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
        if (viewModel.service.hasLocalAuth)
          ListTile(
            leading: SizedBox(height: 40, child: Icon(Icons.settings)),
            trailing: Radio(value: LockType.biometric, groupValue: lockedType, onChanged: (value) {}),
            title: Text("Phone"),
            subtitle: Text("Unlock app base on your phone lock"),
            onTap: () {},
          ),
      ],
    );
  }

  Future<void> onPinCodePressed(BuildContext context) async {
    bool hasLock = viewModel.lockedTypeNotifier.value != null;
    String? value = await showModalActionSheet(
      context: context,
      actions: [
        SheetAction(
          label: hasLock ? "Update PIN code" : "Add PIN code",
          key: "add_update",
          icon: hasLock ? Icons.update : Icons.add,
        ),
        if (hasLock)
          SheetAction(
            label: "Remove PIN code",
            key: "remove",
            isDestructiveAction: true,
            icon: Icons.remove,
          ),
      ],
    );
    switch (value) {
      case "add_update":
        await viewModel.service.setPinLock(context, digit: 4);
        viewModel.load();
        break;
      case "remove":
        await viewModel.service.removeLock(context);
        viewModel.load();
        break;
      default:
    }
  }
}

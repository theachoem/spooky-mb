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
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  leading: SizedBox(height: 40, child: Icon(Icons.pin)),
                  trailing: Radio(value: LockType.pin, groupValue: lockedType, onChanged: (value) {}),
                  title: Text("PIN code"),
                  subtitle: Text("4 digit"),
                  onTap: () => onPinCodePressed(context),
                ),
                ListTile(
                  leading: SizedBox(height: 40, child: Icon(Icons.password)),
                  trailing: Radio(value: LockType.password, groupValue: lockedType, onChanged: (value) {}),
                  title: Text("Password"),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      SpRouteConfig.lock,
                      arguments: LockArgs(
                        flowType: LockFlowType.setPassword,
                      ),
                    );
                  },
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
            ).toList(),
          );
        },
      ),
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

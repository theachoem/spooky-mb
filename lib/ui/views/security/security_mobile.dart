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
              children: ListTile.divideTiles(context: context, tiles: [
                ListTile(
                  leading: SizedBox(height: 40, child: Icon(Icons.pin)),
                  trailing: Radio(value: LockType.pin, groupValue: lockedType, onChanged: (value) {}),
                  title: Text("PIN code"),
                  subtitle: Text("4 digit"),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      SpRouteConfig.lock,
                      arguments: LockArgs(
                        flowType: LockFlowType.setPin,
                      ),
                    );
                  },
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
                if (viewModel.service.hasFaceID)
                  ListTile(
                    leading: SizedBox(height: 40, child: Icon(Icons.settings)),
                    trailing: Radio(value: LockType.biometric, groupValue: lockedType, onChanged: (value) {}),
                    title: Text("Phone"),
                    subtitle: Text("Unlock app base on your phone lock"),
                    onTap: () {},
                  ),
              ]).toList(),
            );
          }),
    );
  }
}

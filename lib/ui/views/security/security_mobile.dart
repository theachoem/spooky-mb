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
      body: ListView(
        children: ListTile.divideTiles(context: context, tiles: [
          ListTile(
            leading: SizedBox(height: 40, child: Icon(Icons.pin)),
            title: Text("PIN code"),
            subtitle: Text("4 digit"),
            onTap: () {},
          ),
          ListTile(
            leading: SizedBox(height: 40, child: Icon(Icons.password)),
            title: Text("Password"),
            onTap: () {},
          ),
          ListTile(
            leading: SizedBox(height: 40, child: Icon(Icons.settings)),
            title: Text("Phone"),
            subtitle: Text("Unlock app base on your phone lock"),
            onTap: () {},
          ),
        ]).toList(),
      ),
    );
  }
}

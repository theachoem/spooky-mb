import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/providers/cloud_service_provider.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

class GoogleAccountTile extends StatelessWidget {
  const GoogleAccountTile({
    Key? key,
    required this.onSignOut,
    required this.onSignIn,
  }) : super(key: key);

  final void Function() onSignOut;
  final void Function() onSignIn;

  @override
  Widget build(BuildContext context) {
    return Consumer<CloudServiceProvider>(
      builder: (context, provider, child) {
        return SpPopupMenuButton(
          dxGetter: (dx) => MediaQuery.of(context).size.width,
          items: (_) {
            return [
              SpPopMenuItem(
                title: "Logout",
                onPressed: () async {
                  await provider.signOutOfGoogle();
                  onSignOut();
                },
              ),
            ];
          },
          builder: (callback) {
            return ListTile(
              title: Text(provider.googleUser?.email ?? "Google Drive"),
              subtitle: Text(provider.googleUser?.displayName ?? "Connect to restore backups"),
              leading: CircleAvatar(child: Icon(CommunityMaterialIcons.google_drive)),
              trailing: SpAnimatedIcons(
                showFirst: provider.googleUser == null,
                firstChild: Icon(Icons.login),
                secondChild: Icon(Icons.more_vert),
              ),
              onTap: provider.googleUser != null
                  ? callback
                  : () async {
                      await provider.signInWithGoogle();
                      onSignIn();
                    },
            );
          },
        );
      },
    );
  }
}

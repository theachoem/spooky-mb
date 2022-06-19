import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spooky/core/backups/providers/google_cloud_provider.dart';
import 'package:spooky/core/services/messenger_service.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/constants/app_constant.dart';
import 'package:spooky/utils/helpers/app_helper.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_pop_up_menu_button.dart';

// TODO: setup this
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
    return Consumer<GoogleCloudProvider>(
      builder: (context, provider, child) {
        return SpPopupMenuButton(
          dxGetter: (dx) => MediaQuery.of(context).size.width,
          items: (_) {
            return [
              if (provider.driveFolderId != null)
                SpPopMenuItem(
                  title: "Photo",
                  leadingIconData: Icons.photo,
                  onPressed: () async {
                    if (provider.driveFolderId != null) {
                      AppHelper.openLinkDialog(
                        'https://drive.google.com/drive/folders/${provider.driveFolderId}?usp=sharing',
                      );
                    } else {
                      MessengerService.instance.showSnackBar(
                        'No images found on "${AppConstant.driveFolderName}" Drive',
                      );
                    }
                  },
                ),
              SpPopMenuItem(
                title: "Logout",
                leadingIconData: Icons.logout,
                titleStyle: TextStyle(color: M3Color.of(context).error),
                onPressed: () async {
                  // final result = await showOkCancelAlertDialog(
                  //   context: context,
                  //   title: "Are you sure?",
                  //   message: "You can log back anytime.",
                  //   isDestructiveAction: true,
                  // );
                  // switch (result) {
                  //   case OkCancelResult.ok:
                  //     await provider.signOutOfGoogle();
                  //     onSignOut();
                  //     break;
                  //   case OkCancelResult.cancel:
                  //     break;
                  // }
                },
              ),
            ];
          },
          builder: (callback) {
            return ListTile(
              title: Text(provider.googleUser?.email ?? "Google Drive"),
              subtitle: Text(provider.googleUser?.displayName ?? "Connect to restore backups"),
              leading: const CircleAvatar(child: Icon(CommunityMaterialIcons.google_drive)),
              trailing: SpAnimatedIcons(
                showFirst: provider.googleUser == null,
                firstChild: const Icon(Icons.login),
                secondChild: const Icon(Icons.more_vert),
              ),
              // onTap: provider.googleUser != null
              //     ? callback
              //     : () async {
              //         await provider.signInWithGoogle();
              //         onSignIn();
              //       },
            );
          },
        );
      },
    );
  }
}

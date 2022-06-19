import 'package:flutter/material.dart';
import 'package:spooky/core/backups/destinations/base_backup_destination.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/widgets/sp_button.dart';

class BackupsDestinationTile extends StatelessWidget {
  const BackupsDestinationTile({
    Key? key,
    required this.destination,
    required this.avatarBuilder,
    required this.actionsBuilder,
  }) : super(key: key);

  final BaseBackupDestination destination;
  final Widget Function(BuildContext) avatarBuilder;
  final List<Widget> Function(BuildContext) actionsBuilder;

  @override
  Widget build(BuildContext context) {
    return destination.buildWithConsumer(
      builder: (context, provider, child) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: ConfigConstant.margin2,
            vertical: ConfigConstant.margin0,
          ),
          child: Material(
            borderOnForeground: false,
            type: MaterialType.button,
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: ConfigConstant.circlarRadius2,
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ListTile(
                      leading: avatarBuilder(context),
                      contentPadding: EdgeInsets.zero,
                      title: Text(provider.title),
                      subtitle: Text(provider.subtitle ?? "Login to sync data"),
                    ),
                    Wrap(
                      children: [
                        if (!provider.isSignedIn)
                          SpButton(
                            label: "Login",
                            onTap: () {
                              provider.signIn();
                            },
                          )
                        else
                          ...actionsBuilder(context)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

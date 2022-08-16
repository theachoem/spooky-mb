import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';
import 'package:spooky/utils/constants/config_constant.dart';

class StoryPadBackupTile extends StatelessWidget {
  const StoryPadBackupTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Theme.of(context).dividerColor),
        borderRadius: ConfigConstant.circlarRadius2,
      ),
      leading: CircleAvatar(
        backgroundImage: buildStoryPadLogo(),
      ),
      title: Text(tr("tile.spooky_restore.title")),
      subtitle: Text(tr("tile.spooky_restore.subtitle")),
      onTap: () {
        Navigator.of(context).pushNamed(SpRouter.storyPadRestore.path);
      },
    );
  }

  CachedNetworkImageProvider buildStoryPadLogo() {
    return const CachedNetworkImageProvider(
      'https://play-lh.googleusercontent.com/BarXSGOfwiTKPZAVgzVonbDVZb5KyD3CjCsXL5t2o-3vJ069pmfeMVyXMM8sgS662hU=w480-h960-rw',
    );
  }
}

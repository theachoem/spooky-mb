import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/routes/sp_router.dart';

class StoryPadBackupTile extends StatelessWidget {
  const StoryPadBackupTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: buildStoryPadLogo(),
      ),
      title: const Text("StoryPad"),
      subtitle: const Text("Migrate from StoryPad to Spooky"),
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

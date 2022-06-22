library clouds_storage_view;

import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/utils/constants/config_constant.dart';
import 'package:spooky/views/cloud_storages/local_widgets/cloud_destination_tile.dart';
import 'package:spooky/views/cloud_storages/local_widgets/storypad_backup_tile.dart';
import 'package:spooky/widgets/sp_expanded_app_bar.dart';
import 'package:spooky/views/cloud_storages/cloud_storages_view_model.dart';

part 'cloud_storages_mobile.dart';

class CloudStoragesView extends StatelessWidget {
  const CloudStoragesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CloudStoragesViewModel>(
      create: (context) => CloudStoragesViewModel(),
      onModelReady: (context, viewModel) {},
      builder: (context, viewModel, child) {
        return _CloudStoragesMobile(viewModel);
      },
    );
  }
}

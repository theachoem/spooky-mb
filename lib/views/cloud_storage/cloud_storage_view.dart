library cloud_storage_view;

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:spooky/core/base/view_model_provider.dart';
import 'package:spooky/core/cloud_storages/base_cloud_storage.dart';
import 'package:spooky/core/cloud_storages/gdrive_storage.dart';
import 'package:spooky/core/models/cloud_file_list_model.dart';
import 'package:spooky/core/models/cloud_file_model.dart';
import 'package:spooky/providers/developer_mode_provider.dart';
import 'package:spooky/theme/m3/m3_color.dart';
import 'package:spooky/utils/helpers/date_format_helper.dart';
import 'package:spooky/widgets/sp_animated_icon.dart';
import 'package:spooky/widgets/sp_icon_button.dart';
import 'package:spooky/widgets/sp_pop_button.dart';
import 'package:spooky/widgets/sp_sections_tiles.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'cloud_storage_view_model.dart';

part 'cloud_storage_mobile.dart';
part 'cloud_storage_tablet.dart';
part 'cloud_storage_desktop.dart';

class CloudStorageView extends StatelessWidget {
  const CloudStorageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CloudStorageViewModel>(
      create: (context) => CloudStorageViewModel(),
      builder: (context, viewModel, child) {
        return ScreenTypeLayout(
          mobile: _CloudStorageMobile(viewModel),
          desktop: _CloudStorageDesktop(viewModel),
          tablet: _CloudStorageTablet(viewModel),
        );
      },
    );
  }
}

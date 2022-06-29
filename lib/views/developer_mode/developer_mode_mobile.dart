part of developer_mode_view;

class _DeveloperModeMobile extends StatelessWidget {
  final DeveloperModeViewModel viewModel;
  const _DeveloperModeMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: ModalRoute.of(context)?.canPop == true ? const SpPopButton() : null,
        title: const SpAppBarTitle(fallbackRouter: SpRouter.developerMode),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            Consumer<NicknameProvider>(
              builder: (context, provider, child) {
                return ListTile(
                  title: const Text("Reset Nickname"),
                  subtitle: Text(provider.name?.isNotEmpty == true ? provider.name! : "Empty"),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    provider.clearNickname();
                    MessengerService.instance.showSnackBar("Cleared");
                  },
                );
              },
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Flexible(
                    child: ListTile(
                      title: const Text("Restart App"),
                      subtitle: const Text("Flutter Level"),
                      onTap: () => Phoenix.rebirth(context),
                    ),
                  ),
                  const VerticalDivider(width: 0),
                  Flexible(
                    child: ListTile(
                      title: const Text("Restart App"),
                      subtitle: const Text("Native Level"),
                      onTap: () => Restart.restartApp(),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                PackageInfo? info = snapshot.data;
                return ListTile(
                  title: const Text("Package Infos"),
                  subtitle: info != null ? Text(info.version) : null,
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  onTap: () async {
                    var map = {
                      "appName": info?.appName,
                      "packageName": info?.packageName,
                      "version": info?.version,
                      "buildNumber": info?.buildNumber,
                      "buildSignature": info?.buildSignature,
                    };

                    showOkAlertDialog(
                      context: context,
                      message: map.entries
                          .map((e) {
                            return "${e.key.capitalize}: ${e.value}";
                          })
                          .toList()
                          .join("\n"),
                    );
                  },
                );
              },
            ),
            // Container(
            //   height: 300,
            //   child: _DriveFiles(),
            // )
          ],
        ).toList(),
      ),
    );
  }
}

// class _DriveFiles extends StatefulWidget {
//   const _DriveFiles({Key? key}) : super(key: key);

//   @override
//   State<_DriveFiles> createState() => _DriveFilesState();
// }

// class _DriveFilesState extends State<_DriveFiles> {
//   GDriveBackupStorage storage = GDriveBackupStorage();
//   CloudFileListModel? fileList;
//   Set<String> selectedIds = {};

//   Future<void> load() async {
//     fileList = await storage.execHandler(() => storage.list({"next_token": fileList?.nextToken}));
//     setState(() {});
//   }

//   Future<void> delete() async {
//     for (String id in selectedIds) {
//       print("ID: $id");
//       await storage.delete({'file_id': id});
//     }
//     load();
//   }

//   @override
//   void initState() {
//     super.initState();
//     load();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         ListView.builder(
//           itemCount: fileList?.files.length ?? 0,
//           itemBuilder: (context, index) {
//             CloudFileModel file = fileList!.files[index];
//             bool selected = selectedIds.contains(file.id);
//             return CheckboxListTile(
//               title: Text(file.fileName ?? ""),
//               subtitle: Text(file.id),
//               onChanged: (bool? value) {
//                 if (selected) {
//                   selectedIds.remove(file.id);
//                 } else {
//                   selectedIds.add(file.id);
//                 }
//                 setState(() {});
//               },
//               value: selected,
//             );
//           },
//         ),
//         SpIconButton(
//           icon: Icon(Icons.delete),
//           onPressed: () {
//             delete();
//           },
//         )
//       ],
//     );
//   }
// }

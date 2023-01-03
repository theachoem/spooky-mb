part of 'sp_router.dart';

class InitPickColorArgs {
  const InitPickColorArgs({this.key, required this.showNextButton});

  final Key? key;

  final bool showNextButton;

  @override
  String toString() {
    return 'InitPickColorArgs{key: $key, showNextButton: $showNextButton}';
  }
}

class LockArgs {
  const LockArgs({this.key, required this.flowType});

  final Key? key;

  final LockFlowType flowType;

  @override
  String toString() {
    return 'LockArgs{key: $key, flowType: $flowType}';
  }
}

class BackupsDetailArgs {
  const BackupsDetailArgs(
      {this.key, required this.destination, required this.cloudFiles, required this.initialCloudFile});

  final Key? key;

  final BaseBackupDestination<BaseCloudProvider> destination;

  final List<CloudFileTuple> cloudFiles;

  final CloudFileModel initialCloudFile;

  @override
  String toString() {
    return 'BackupsDetailArgs{key: $key, destination: $destination, cloudFiles: $cloudFiles, initialCloudFile: $initialCloudFile}';
  }
}

class ChangesHistoryArgs {
  const ChangesHistoryArgs(
      {this.key, required this.story, required this.onRestorePressed, required this.onDeletePressed});

  final Key? key;

  final StoryDbModel story;

  final void Function(int, StoryDbModel) onRestorePressed;

  final Future<StoryDbModel> Function(List<int>, StoryDbModel) onDeletePressed;

  @override
  String toString() {
    return 'ChangesHistoryArgs{key: $key, story: $story, onRestorePressed: $onRestorePressed, onDeletePressed: $onDeletePressed}';
  }
}

class ContentReaderArgs {
  const ContentReaderArgs({this.key, required this.content});

  final Key? key;

  final StoryContentDbModel content;

  @override
  String toString() {
    return 'ContentReaderArgs{key: $key, content: $content}';
  }
}

class DetailArgs {
  const DetailArgs({this.key, required this.initialStory, required this.intialFlow});

  final Key? key;

  final StoryDbModel initialStory;

  final DetailViewFlowType intialFlow;

  @override
  String toString() {
    return 'DetailArgs{key: $key, initialStory: $initialStory, intialFlow: $intialFlow}';
  }
}

class HomeArgs {
  const HomeArgs({
    this.key,
    required this.onMonthChange,
    required this.onYearChange,
    required this.onTagChange,
  });

  final Key? key;

  final void Function(int) onMonthChange;

  final void Function(int) onYearChange;

  final void Function(String?) onTagChange;

  @override
  String toString() {
    return 'HomeArgs{key: $key, onMonthChange: $onMonthChange, onYearChange: $onYearChange, onTagChange: $onTagChange}';
  }
}

class ManagePagesArgs {
  const ManagePagesArgs({this.key, required this.content});

  final Key? key;

  final StoryContentDbModel content;

  @override
  String toString() {
    return 'ManagePagesArgs{key: $key, content: $content}';
  }
}

class SearchArgs {
  const SearchArgs({this.key, required this.initialQuery, this.displayTag});

  final Key? key;

  final StoryQueryOptionsModel? initialQuery;

  final String? displayTag;

  @override
  String toString() {
    return 'SearchArgs{key: $key, initialQuery: $initialQuery, displayTag: $displayTag}';
  }
}

class BackupHistoriesManagerArgs {
  const BackupHistoriesManagerArgs({this.key, required this.destination});

  final Key? key;

  final BaseBackupDestination<BaseCloudProvider> destination;

  @override
  String toString() {
    return 'BackupHistoriesManagerArgs{key: $key, destination: $destination}';
  }
}

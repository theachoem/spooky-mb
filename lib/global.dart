part of 'main.dart';

class Global {
  Global._();
  static final Global instance = Global._();

  // HELPERS
  final _purchasedAddOnStorage = PurchasedAddOnStorage();

  // GLOBAL VAR
  String? _nickname;
  List<String>? _purchases;
  List<TagDbModel>? _tags;
  SpListLayoutType? _layoutType;
  PackageInfo? _platform;

  Future<void> _initiailize() async {
    _nickname = await NicknameStorage().read();
    _purchases = await _purchasedAddOnStorage.readList() ?? [];
    _tags = await TagDatabase.instance.fetchAll().then((value) => value?.items) ?? [];
    _layoutType = await SpListLayoutTypeStorage().readEnum();
    _platform = await PackageInfo.fromPlatform();
    return;
  }

  // ACCESSIBLE
  bool get unitTesting => Platform.environment.containsKey('FLUTTER_TEST');
  bool get appInitiailized => _nickname != null;
  PackageInfo get platform {
    if (unitTesting) return _testingPlatform;
    if (_platform == null) throw ErrorSummary("Required initialize [Global] in main()");
    return _platform!;
  }

  List<String> get purchases => _purchases!;
  List<TagDbModel> get tags => _tags!;
  SpListLayoutType get layoutType => _layoutType ?? SpListLayoutBuilder.defaultLayout;
  PackageInfo get _testingPlatform =>
      PackageInfo(appName: "unit-test", packageName: "test.unit.com", version: "1.0.0", buildNumber: "1");

  // SETTER
  set nickname(String? value) => _nickname = value;
  void setLayoutType(SpListLayoutType value) => _layoutType = value;
  void setTags(List<TagDbModel> value) => _tags = value;
}

part of 'main.dart';

class Global {
  Global._();
  static final Global instance = Global._();

  // HELPERS
  final _purchasedAddOnStorage = PurchasedAddOnStorage();

  // GLOBAL VAR
  String? _nickname;
  List<String>? _purchases;
  PackageInfo? _platform;

  Future<void> _initiailize() async {
    _nickname = await NicknameStorage().read();
    _purchases = await _purchasedAddOnStorage.readList() ?? [];
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
  PackageInfo get _testingPlatform =>
      PackageInfo(appName: "unit-test", packageName: "test.unit.com", version: "1.0.0", buildNumber: "1");

  // SETTER
  set nickname(String? value) => _nickname = value;
}

part of 'main.dart';

class Global {
  Global._();
  static final Global instance = Global._();

  // HELPERS
  final _purchasedAddOnStorage = PurchasedAddOnStorage();

  // GLOBAL VAR
  String? _nickname;
  List<String>? _purchases;

  Future<void> _initiailize() async {
    _nickname = await NicknameStorage().read();
    _purchases = await _purchasedAddOnStorage.readList();
    _purchases ??= [];
    return;
  }

  // ACCESSIBLE
  bool get unitTesting => Platform.environment.containsKey('FLUTTER_TEST');
  bool get appInitiailized => _nickname != null;
  List<String> get purchases => _purchases!;

  // SETTER
  set nickname(String? value) => _nickname = value;
}

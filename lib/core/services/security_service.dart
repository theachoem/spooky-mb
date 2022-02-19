import 'package:local_auth/local_auth.dart';
import 'package:spooky/core/storages/local_storages/security/security_storage.dart';

class SecurityService {
  static final LocalAuthentication _localAuth = LocalAuthentication();
  static final SecurityStorage _storage = SecurityStorage();

  static bool? _hasFaceID;
  static bool? _hasFingerprint;
  static bool? _hasIris;

  bool get hasFaceID => _hasFaceID ?? false;
  bool get hasFingerprint => _hasFingerprint ?? false;
  bool get hasIris => _hasIris ?? false;

  bool get hasLocalAuth => hasFaceID || hasFingerprint || hasIris;

  static Future<void> initialize() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics && await _localAuth.isDeviceSupported();
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      _hasFaceID = availableBiometrics.contains(BiometricType.face);
      _hasFaceID = availableBiometrics.contains(BiometricType.fingerprint);
      _hasIris = availableBiometrics.contains(BiometricType.iris);
    }
  }

  Future<SecurityObject?> getLock() => _storage.getLock();
}

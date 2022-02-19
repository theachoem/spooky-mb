import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  LocalAuthentication localAuth = LocalAuthentication();

  bool? _hasFaceID;
  bool? _hasFingerprint;
  bool? _hasIris;

  bool get hasFaceID => _hasFaceID ?? false;
  bool get hasFingerprint => _hasFingerprint ?? false;
  bool get hasIris => _hasIris ?? false;

  Future<void> initialize() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics && await localAuth.isDeviceSupported();
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics = await localAuth.getAvailableBiometrics();
      _hasFaceID = availableBiometrics.contains(BiometricType.face);
      _hasFaceID = availableBiometrics.contains(BiometricType.fingerprint);
      _hasIris = availableBiometrics.contains(BiometricType.iris);
    }
  }

  authenticate() {
    localAuth.authenticate(
      localizedReason: "Please authenticate to enter the app",
    );
  }
}

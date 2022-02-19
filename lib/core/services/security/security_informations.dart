part of security_service;

class _SecurityInformations {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final SecurityStorage _storage = SecurityStorage();

  bool? _hasFaceID;
  bool? _hasFingerprint;
  bool? _hasIris;

  bool get hasFaceID => _hasFaceID ?? false;
  bool get hasFingerprint => _hasFingerprint ?? false;
  bool get hasIris => _hasIris ?? false;

  bool get hasLocalAuth => hasFaceID || hasFingerprint || hasIris;

  Future<void> initialize() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics && await _localAuth.isDeviceSupported();
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      _hasFaceID = availableBiometrics.contains(BiometricType.face);
      _hasFaceID = availableBiometrics.contains(BiometricType.fingerprint);
      _hasIris = availableBiometrics.contains(BiometricType.iris);
    }
  }
}

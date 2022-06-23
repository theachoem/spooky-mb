part of security_service;

// store basic info & methods for security_service
class _SecurityInformations {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final SecurityStorage _storage = SecurityStorage();

  bool? _hasFaceID;
  bool? _hasFingerprint;
  bool? _hasIris;
  bool? _hasStrong;
  bool? _hasWeak;

  bool get hasFaceID => _hasFaceID ?? false;
  bool get hasFingerprint => _hasFingerprint ?? false;
  bool get hasIris => _hasIris ?? false;
  bool get hasStrong => _hasStrong ?? false;
  bool get hasWeak => _hasWeak ?? false;

  bool get hasLocalAuth => hasFaceID || hasFingerprint || hasIris || hasStrong || hasWeak;

  Future<void> initialize() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics && await _localAuth.isDeviceSupported();
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      _hasFaceID = availableBiometrics.contains(BiometricType.face);
      _hasFingerprint = availableBiometrics.contains(BiometricType.fingerprint);
      _hasIris = availableBiometrics.contains(BiometricType.iris);
      _hasStrong = availableBiometrics.contains(BiometricType.strong);
      _hasWeak = availableBiometrics.contains(BiometricType.weak);
    }
  }

  Future<SecurityObject?> getLock() => _storage.getLock();
  Future<void> clear() => _storage.clearLock();
}

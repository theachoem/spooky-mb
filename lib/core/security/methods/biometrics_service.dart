part of security_service;

class _BiometricsService extends _BaseLockService<_BiometricsOptions> {
  final _SecurityInformations info;
  _BiometricsService(this.info);

  @override
  Future<bool> unlock(_BiometricsOptions option) async {
    assert(option.object != null);
    if (!info.hasLocalAuth) return true;

    bool authenticate = await enhancedScreenLock(
      context: option.context,
      correctString: option.object!.secret,
      customizedButtonChild: Icon(Icons.fingerprint),
      didUnlocked: () => Navigator.of(option.context).pop(true),
      customizedButtonTap: () async {
        bool authenticated = await _authentication();
        if (authenticated) Navigator.of(option.context).pop(true);
      },
      canCancel: false,
      didOpened: () async {
        bool authenticated = await _authentication();
        if (authenticated) Navigator.of(option.context).pop(true);
      },
    );

    return option.next(authenticate);
  }

  @override
  Future<bool> set(_BiometricsOptions option) async {
    bool authenticated = await _authentication();
    return option.next(authenticated);
  }

  @override
  Future<bool> update(_BiometricsOptions option) async {
    bool authenticated = await unlock(option);
    if (authenticated) {
      return set(option);
    } else {
      return authenticated;
    }
  }

  @override
  Future<bool> remove(_BiometricsOptions option) async {
    bool authenticated = await _authentication();
    if (authenticated) await info._storage.clearLock();
    return option.next(authenticated);
  }

  Future<bool> _authentication([
    String title = "Unlock to open the app",
  ]) async {
    try {
      return info._localAuth.authenticate(
        localizedReason: title,
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      switch (e.code) {
        case code.lockedOut:
          break;
        case code.notAvailable:
          OpenSettings.openSecuritySetting();
          break;
        case code.notEnrolled:
          break;
        case code.otherOperatingSystem:
          break;
        case code.passcodeNotSet:
          break;
        case code.permanentlyLockedOut:
          break;
      }
    }
    return false;
  }
}

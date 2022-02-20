part of security_service;

class _PinCodeService extends _BaseLockService<_PinCodeOptions> {
  final _SecurityInformations info;
  _PinCodeService(this.info);

  @override
  Future<bool> unlock(_PinCodeOptions option) async {
    assert(option.object != null);

    bool authenticated = await _confirmOwnership(
      context: option.context,
      secret: option.object!.secret,
      canCancel: option.canCancel,
    );

    return option.next(authenticated);
  }

  @override
  Future<bool> set(_PinCodeOptions option) async {
    String? matchedSecret = await enhancedScreenLock<String>(
      digits: 4,
      context: option.context,
      correctString: '',
      title: const HeadingTitle(text: 'Please enter new passcode'),
      confirmation: true,
      didConfirmed: (matchedSecret) {
        Navigator.of(option.context).pop(matchedSecret);
      },
    );
    if (matchedSecret != null) {
      info._storage.setLock(option.lockType, matchedSecret);
      return option.next(true);
    } else {
      return option.next(false);
    }
  }

  @override
  Future<bool> remove(_PinCodeOptions option) async {
    assert(option.object != null);
    bool authenticated = await _confirmOwnership(
      context: option.context,
      secret: option.object!.secret,
      canCancel: option.canCancel,
    );
    if (authenticated) await info.clear();
    return option.next(authenticated);
  }

  Future<bool> _confirmOwnership({
    required BuildContext context,
    required String secret,
    bool canCancel = false,
  }) async {
    bool? authenticated = await enhancedScreenLock<bool>(
      context: context,
      correctString: secret,
      canCancel: canCancel,
      didUnlocked: () {
        Navigator.of(context).pop(true);
      },
    );
    return authenticated == true;
  }
}

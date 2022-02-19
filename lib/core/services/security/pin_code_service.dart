part of security_service;

class _PinCodeService extends _BaseLockService<_PinCodeOptions> {
  final _SecurityInformations info;
  _PinCodeService(this.info);

  @override
  Future<bool> remove(_PinCodeOptions option) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<bool> set(_PinCodeOptions option) {
    // TODO: implement set
    throw UnimplementedError();
  }

  @override
  Future<bool> unlock(_PinCodeOptions option) {
    // TODO: implement unlock
    throw UnimplementedError();
  }

  @override
  Future<bool> update(_PinCodeOptions option) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

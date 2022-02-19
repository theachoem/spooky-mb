part of security_service;

class _PasswordService extends _BaseLockService<_PasswordOptions> {
  final _SecurityInformations info;
  _PasswordService(this.info);

  @override
  Future<bool> unlock(_PasswordOptions option) {
    // TODO: implement unlock
    throw UnimplementedError();
  }

  @override
  Future<bool> set(_PasswordOptions option) {
    // TODO: implement set
    throw UnimplementedError();
  }

  @override
  Future<bool> update(_PasswordOptions option) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<bool> remove(_PasswordOptions option) {
    // TODO: implement remove
    throw UnimplementedError();
  }
}

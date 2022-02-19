part of security_service;

class _BiometricsService extends _BaseLockService<_BiometricsOptions> {
  final _SecurityInformations info;
  _BiometricsService(this.info);

  @override
  Future<bool> remove(_BiometricsOptions option) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<bool> set(_BiometricsOptions option) {
    // TODO: implement set
    throw UnimplementedError();
  }

  @override
  Future<bool> unlock(_BiometricsOptions option) {
    // TODO: implement unlock
    throw UnimplementedError();
  }

  @override
  Future<bool> update(_BiometricsOptions option) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

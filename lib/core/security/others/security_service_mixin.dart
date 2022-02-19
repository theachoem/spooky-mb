part of security_service;

mixin _SecurityServiceMixin {
  Future<SecurityObject?> getObject(_SecurityInformations lockInfo) async {
    SecurityObject? value = await lockInfo.getLock();
    LockType? type = value?.type;
    String? secret = value?.secret;
    if (secret == null || type == null) {
      await lockInfo._storage.clearLock();
      return null;
    } else {
      return value;
    }
  }
}

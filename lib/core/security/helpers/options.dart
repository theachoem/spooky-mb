part of security_service;

abstract class _BaseLockOptions {
  final BuildContext context;
  final SecurityObject? object;
  final Future<bool> Function(bool authenticated) next;
  final LockType lockType;

  _BaseLockOptions({
    required this.context,
    required this.object,
    required this.lockType,
    required this.next,
  });
}

class _BiometricsOptions extends _BaseLockOptions {
  _BiometricsOptions({
    required BuildContext context,
    required SecurityObject? object,
    required LockType lockType,
    required Future<bool> Function(bool authenticated) next,
  }) : super(context: context, object: object, lockType: lockType, next: next);
}

class _PasswordOptions extends _BaseLockOptions {
  _PasswordOptions({
    required BuildContext context,
    required SecurityObject? object,
    required LockType lockType,
    required Future<bool> Function(bool authenticated) next,
  }) : super(context: context, object: object, lockType: lockType, next: next);
}

class _PinCodeOptions extends _BaseLockOptions {
  _PinCodeOptions({
    required BuildContext context,
    required SecurityObject? object,
    required LockType lockType,
    required Future<bool> Function(bool authenticated) next,
  }) : super(context: context, object: object, lockType: lockType, next: next);
}

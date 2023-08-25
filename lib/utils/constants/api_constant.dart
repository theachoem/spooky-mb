class ApiConstant {
  static const String flavor = String.fromEnvironment('FLAVOR');

  static const bool dev = flavor == 'DEVELOPMENT';
  static const bool staging = flavor == 'STAGING';
  static const bool prod = flavor == 'PRODUCTION';
}

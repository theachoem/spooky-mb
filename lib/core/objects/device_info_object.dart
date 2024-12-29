import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoObject {
  final String model;
  final String id;

  DeviceInfoObject(this.model, this.id);

  static Future<DeviceInfoObject> get() async {
    bool unitTesting = Platform.environment.containsKey('FLUTTER_TEST');
    if (unitTesting) return DeviceInfoObject("Device Model", "device_id");

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? device;
    String? id;

    if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      device = info.model;
      id = info.identifierForVendor;
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      device = info.model;
      id = info.id;
    }

    if (Platform.isMacOS) {
      MacOsDeviceInfo info = await deviceInfo.macOsInfo;
      device = info.model;
      id = info.systemGUID;
    }

    if (Platform.isWindows) {
      WindowsDeviceInfo info = await deviceInfo.windowsInfo;
      device = info.computerName;
      id = info.computerName;
    }

    if (Platform.isLinux) {
      LinuxDeviceInfo info = await deviceInfo.linuxInfo;
      device = info.name;
      id = info.machineId;
    }

    return DeviceInfoObject(device ?? "Unknown", id ?? "unknown_id");
  }
}

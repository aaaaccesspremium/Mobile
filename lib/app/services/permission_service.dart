import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

abstract class PermissionService {
  Future<bool> ensureCameraAccess();
  Future<bool> ensureMediaAccess();
  Future<void> openAppSettings();
}

class DevicePermissionService implements PermissionService {
  DevicePermissionService({DeviceInfoPlugin? deviceInfo})
      : _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _deviceInfo;

  @override
  Future<bool> ensureCameraAccess() async {
    final status = await permission_handler.Permission.camera.request();
    return status == permission_handler.PermissionStatus.granted ||
        status == permission_handler.PermissionStatus.limited;
  }

  @override
  Future<bool> ensureMediaAccess() async {
    if (Platform.isIOS) {
      final status = await permission_handler.Permission.photosAddOnly.request();
      return status == permission_handler.PermissionStatus.granted ||
          status == permission_handler.PermissionStatus.limited;
    }

    if (Platform.isAndroid) {
      final sdkInt = await _androidSdkInt();
      if (sdkInt >= 33) {
        final status = await permission_handler.Permission.photos.request();
        return status == permission_handler.PermissionStatus.granted ||
            status == permission_handler.PermissionStatus.limited;
      }
      final status = await permission_handler.Permission.storage.request();
      return status == permission_handler.PermissionStatus.granted;
    }

    return true;
  }

  Future<int> _androidSdkInt() async {
    try {
      final info = await _deviceInfo.androidInfo;
      return info.version.sdkInt;
    } catch (_) {
      return 33;
    }
  }

  @override
  Future<void> openAppSettings() {
    return permission_handler.openAppSettings();
  }
}

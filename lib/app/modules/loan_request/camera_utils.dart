import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

/// Requests camera permission and returns the back camera description.
Future<CameraDescription> ensureCameraReady() async {
  final status = await Permission.camera.request();
  if (!status.isGranted) {
    throw CameraException('PERMISSION_DENIED', 'Camera permission not granted');
  }
  final cameras = await availableCameras();
  return cameras.firstWhere(
    (c) => c.lensDirection == CameraLensDirection.back,
    orElse: () => cameras.first,
  );
}

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'camera_utils.dart';

enum CapturePurpose { cardFront, ineFront, ineBack, docPhoto }

/// Widget that automatically captures a document when a stable rectangle is detected.
class AutoCaptureScreen extends StatefulWidget {
  final String title;
  final CapturePurpose purpose;
  final void Function(XFile file) onSaved;
  final String nextRoute;
  final String? initialPath;

  const AutoCaptureScreen({
    super.key,
    required this.title,
    required this.purpose,
    required this.onSaved,
    required this.nextRoute,
    this.initialPath,
  });

  @override
  State<AutoCaptureScreen> createState() => _AutoCaptureScreenState();
}

class _AutoCaptureScreenState extends State<AutoCaptureScreen> {
  CameraController? _controller;
  bool _initialized = false;
  final DocumentScanner _scanner = DocumentScanner();
  Rect? _detectedRect;
  Timer? _stabilityTimer;
  Timer? _countdownTimer;
  int? _countdown;
  XFile? _capturedFile;
  DateTime _lastDetectionProcess = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final camera = await ensureCameraReady();
      _controller = CameraController(camera, ResolutionPreset.high, enableAudio: false);
      await _controller!.initialize();
      await _controller!.startImageStream(_processCameraImage);
      if (mounted && widget.initialPath != null) {
        _capturedFile = XFile(widget.initialPath!);
      }
      setState(() => _initialized = true);
    } catch (_) {
      // Permission denied or camera unavailable
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _countdownTimer?.cancel();
    _stabilityTimer?.cancel();
    _scanner.close();
    super.dispose();
  }

  Future<void> _processCameraImage(CameraImage image) async {
    // Process only 3 frames per second.
    if (DateTime.now().difference(_lastDetectionProcess) < const Duration(milliseconds: 300)) {
      return;
    }
    _lastDetectionProcess = DateTime.now();
    if (_controller == null || !_controller!.value.isStreamingImages) return;

    try {
      final inputImage = InputImage.fromBytes(
        bytes: _concatenatePlanes(image.planes),
        inputImageData: InputImageData(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          imageRotation: InputImageRotation.rotation0deg,
          inputImageFormat: InputImageFormatMethods.fromRawValue(image.format.raw) ??
              InputImageFormat.nv21,
          planeData: image.planes
              .map((plane) => InputImagePlaneMetadata(
                    bytesPerRow: plane.bytesPerRow,
                    height: plane.height,
                    width: plane.width,
                  ))
              .toList(),
        ),
      );
      final document = await _scanner.processImage(inputImage);
      if (document.blocks.isNotEmpty) {
        final rect = document.blocks.first.boundingBox;
        _onRectDetected(rect);
      } else {
        _onRectLost();
      }
    } catch (_) {
      // fallback to edge_detection, which only tells if a rectangle exists
      _onRectLost();
    }
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  void _onRectDetected(Rect rect) {
    _detectedRect = rect;
    _stabilityTimer ??= Timer(const Duration(seconds: 1), _startCountdown);
  }

  void _onRectLost() {
    _detectedRect = null;
    _stabilityTimer?.cancel();
    _stabilityTimer = null;
    _cancelCountdown();
  }

  void _startCountdown() {
    if (_detectedRect == null || _countdown != null) return;
    _countdown = 3;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == null) return;
      setState(() => _countdown = _countdown! - 1);
      if (_countdown == 0) {
        timer.cancel();
        _countdown = null;
        _takePicture();
      }
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    if (_countdown != null) {
      setState(() => _countdown = null);
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null) return;
    try {
      final file = await _controller!.takePicture();
      Rect? rect = _detectedRect;
      XFile output = file;
      if (rect != null) {
        output = await _cropToRect(file, rect);
      } else {
        // try edge detection as fallback
        final tempDir = await getTemporaryDirectory();
        final path = p.join(tempDir.path, 'edge_${DateTime.now().millisecondsSinceEpoch}.jpg');
        final detected = await EdgeDetection.detectEdge(file.path, path: path);
        if (detected) {
          output = XFile(path);
        }
      }
      setState(() {
        _capturedFile = output;
      });
      widget.onSaved(output);
    } catch (e) {
      debugPrint('Capture error: $e');
    }
  }

  Future<XFile> _cropToRect(XFile file, Rect rect) async {
    final bytes = await file.readAsBytes();
    final original = img.decodeImage(bytes);
    if (original == null) return file;
    // rect is relative to image size from camera preview
    final width = original.width;
    final height = original.height;
    final cropRect = Rect.fromLTWH(
      max(0, rect.left).clamp(0, width.toDouble()),
      max(0, rect.top).clamp(0, height.toDouble()),
      min(rect.width, width.toDouble()),
      min(rect.height, height.toDouble()),
    );
    final cropped = img.copyCrop(
      original,
      x: cropRect.left.round(),
      y: cropRect.top.round(),
      width: cropRect.width.round(),
      height: cropRect.height.round(),
    );
    final tempDir = await getTemporaryDirectory();
    final path =
        p.join(tempDir.path, '${widget.purpose.name}_${DateTime.now().millisecondsSinceEpoch}.jpg');
    final encoded = img.encodeJpg(cropped);
    final fileOut = await File(path).writeAsBytes(encoded);
    return XFile(fileOut.path);
  }

  void _retry() {
    setState(() => _capturedFile = null);
    _cancelCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                if (_capturedFile == null)
                  CameraPreview(_controller!),
                if (_capturedFile == null) _buildOverlay(),
                if (_capturedFile != null)
                  Positioned.fill(
                    child: Image.file(File(_capturedFile!.path), fit: BoxFit.cover),
                  ),
                if (_countdown != null)
                  Center(
                    child: Text(
                      '$_countdown',
                      style: const TextStyle(fontSize: 80, color: Colors.white),
                    ),
                  ),
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: _capturedFile == null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Alinea el borde del documento dentro del marco',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _takePicture,
                              child: const Text('Capturar manualmente'),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Get.back(),
              child: const Text('Volver'),
            ),
          ),
          if (_capturedFile != null) ...[
            Expanded(
              child: TextButton(
                onPressed: _retry,
                child: const Text('Reintentar'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => Get.toNamed(widget.nextRoute),
                child: const Text('Siguiente'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        // Determine rect for document ratio 1.586:1
        final frameWidth = width * 0.9;
        final frameHeight = frameWidth / 1.586;
        final top = (height - frameHeight) / 2;
        final left = (width - frameWidth) / 2;
        return Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.black45),
            ),
            Positioned(
              top: top,
              left: left,
              width: frameWidth,
              height: frameHeight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.transparent,
                ),
              ),
            ),
            // Clear the inside of frame
            Positioned(
              top: top,
              left: left,
              width: frameWidth,
              height: frameHeight,
              child: ClipPath(
                clipper: _RectClipper(),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RectClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoanCameraPage extends StatefulWidget {
  const LoanCameraPage({super.key});

  @override
  State<LoanCameraPage> createState() => _LoanCameraPageState();
}

class _LoanCameraPageState extends State<LoanCameraPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initFuture;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      _controller = controller;
      _initFuture = controller.initialize();
      setState(() {});
    } catch (e) {
      debugPrint('Error inicializando cámara: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo inicializar la cámara')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _takePhoto() async {
    final controller = _controller;
    if (controller == null) return;

    try {
      await _initFuture;
      if (!controller.value.isInitialized || controller.value.isTakingPicture) {
        return;
      }
      final XFile file = await controller.takePicture();
      if (!mounted) return;
      Navigator.pop(context, file); // devolvemos la foto
    } catch (e) {
      debugPrint('Error al tomar foto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo tomar la foto')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (controller != null)
              FutureBuilder(
                future: _initFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      controller.value.isInitialized) {
                    return Center(child: CameraPreview(controller));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            else
              const Center(child: CircularProgressIndicator()),

            // Cancelar
            Positioned(
              top: 12,
              left: 12,
              child: IconButton(
                iconSize: 32,
                color: Colors.white,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context, null),
              ),
            ),

            // Tomar foto
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar foto'),
                  onPressed: _takePhoto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

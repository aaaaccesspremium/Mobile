import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Tipos de documento requeridos
enum LoanDocKind { ineFront, ineBack, comprobante }

extension LoanDocKindX on LoanDocKind {
  String get title {
    switch (this) {
      case LoanDocKind.ineFront:
        return 'INE - Frente';
      case LoanDocKind.ineBack:
        return 'INE - Reverso';
      case LoanDocKind.comprobante:
        return 'Documento';
    }
  }

  String get helper {
    switch (this) {
      case LoanDocKind.ineFront:
        return 'Alinea el frente de tu INE dentro del marco';
      case LoanDocKind.ineBack:
        return 'Alinea el reverso de tu INE dentro del marco';
      case LoanDocKind.comprobante:
        return 'Alinea el documento dentro del marco';
    }
  }

  double get aspectRatio {
    switch (this) {
      case LoanDocKind.ineFront:
      case LoanDocKind.ineBack:
        return 1.586; // 85.6x54mm
      case LoanDocKind.comprobante:
        return 1.414; // √2
    }
  }
}

class LoanCameraPage extends StatefulWidget {
  final LoanDocKind kind;
  const LoanCameraPage({super.key, required this.kind});

  @override
  State<LoanCameraPage> createState() => _LoanCameraPageState();
}

class _LoanCameraPageState extends State<LoanCameraPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController? _controller;
  Future<void>? _initFuture;
  late final AnimationController _shutterCtrl;
  late final Animation<double> _shutterScale;
  bool _flashVisible = false;
  bool _torchOn = false;

  bool get _hasTorch => _controller?.value.isInitialized ?? false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _shutterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _shutterScale = Tween(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _shutterCtrl, curve: Curves.easeOut),
    );
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
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller?.dispose();
    _shutterCtrl.dispose();
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

  Future<void> _capturePhoto() async {
    final controller = _controller;
    if (controller == null) return;

    try {
      await _initFuture;
      if (!controller.value.isInitialized || controller.value.isTakingPicture) {
        return;
      }
      _playShutterFx();
      final XFile file = await controller.takePicture();
      if (!mounted) return;
      Navigator.pop(context, file);
    } catch (e) {
      debugPrint('Error al tomar foto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo tomar la foto')),
        );
      }
    }
  }

  void _playShutterFx() {
    HapticFeedback.lightImpact();
    _shutterCtrl.forward(from: 0).then((_) => _shutterCtrl.reverse());
    setState(() => _flashVisible = true);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _flashVisible = false);
    });
  }

  Future<void> _toggleTorch() async {
    final controller = _controller;
    if (controller == null) return;
    _torchOn = !_torchOn;
    try {
      await controller.setFlashMode(
          _torchOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
    } catch (_) {
      _torchOn = false;
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
                    return CameraPreview(controller);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )
            else
              const Center(child: CircularProgressIndicator()),
            _buildOverlay(),
            AnimatedOpacity(
              opacity: _flashVisible ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Container(color: Colors.white),
            ),
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
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ScaleTransition(
                      scale: _shutterScale,
                      child: GestureDetector(
                        onTap: _capturePhoto,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                        ),
                      ),
                    ),
                    if (_hasTorch)
                      Positioned(
                        right: 32,
                        child: IconButton(
                          color: Colors.white,
                          iconSize: 32,
                          icon: Icon(
                            _torchOn
                                ? Icons.flashlight_on
                                : Icons.flashlight_off,
                          ),
                          onPressed: _toggleTorch,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final ratio = widget.kind.aspectRatio;
        double width = size.width - 32;
        double height = width / ratio;
        if (height > size.height - 120) {
          height = size.height - 120;
          width = height * ratio;
        }
        final rect = Rect.fromCenter(
          center: size.center(Offset.zero),
          width: width,
          height: height,
        );
        return Stack(
          children: [
            CustomPaint(size: size, painter: _OverlayPainter(rect)),
            Positioned.fromRect(
              rect: rect,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Text(
                widget.kind.helper,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Rect hole;
  _OverlayPainter(this.hole);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black45;
    final overlay = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutout = Path()
      ..addRRect(RRect.fromRectAndRadius(hole, const Radius.circular(16)));
    canvas.drawPath(Path.combine(PathOperation.difference, overlay, cutout), paint);
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) =>
      oldDelegate.hole != hole;
}
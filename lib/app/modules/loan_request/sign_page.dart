import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

import 'loan_request_provider.dart';
import '../../routes/app_routes.dart';

class SignPage extends ConsumerStatefulWidget {
  const SignPage({super.key});

  @override
  ConsumerState<SignPage> createState() => _SignPageState();
}

class _SignPageState extends ConsumerState<SignPage> {
  final SignatureController _controller =
      SignatureController(penColor: Colors.black, penStrokeWidth: 3);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    if (_controller.isEmpty) return;
    try {
      final bytes = await _controller.toPngBytes(
        backgroundColor: Colors.white,
        height: 300,
        width: 1000,
      );
      if (bytes == null) return;
      final dir = await getTemporaryDirectory();
      final path =
          p.join(dir.path, 'sign_${DateTime.now().millisecondsSinceEpoch}.png');
      final file = File(path);
      await file.writeAsBytes(bytes);
      ref.read(loanRequestProvider.notifier).setSignaturePath(path);
      Get.toNamed(AppRoutes.loanReview);
    } catch (e) {
      debugPrint('Signature error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firma')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Signature(
                controller: _controller,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _controller.clear();
                      ref
                          .read(loanRequestProvider.notifier)
                          .clearSignature();
                    },
                    child: const Text('Limpiar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _controller.isEmpty
                        ? null
                        : () {
                            _controller.undo();
                          },
                    child: const Text('Deshacer'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveAndContinue,
                    child: const Text('Guardar y continuar'),
                  ),
                ),
              ],
            ),
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
        ],
      ),
    );
  }
}

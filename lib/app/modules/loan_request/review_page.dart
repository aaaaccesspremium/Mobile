import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import 'loan_request_provider.dart';
import 'loan_request_service.dart';

class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({super.key});

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  bool _sending = false;

  Future<void> _submit() async {
    final state = ref.read(loanRequestProvider);
    final service = ref.read(loanRequestServiceProvider);
    setState(() => _sending = true);
    try {
      await service.submit(state);
      Get.snackbar('Éxito', 'Solicitud enviada');
      ref.read(loanRequestProvider.notifier).clear();
      Get.offAllNamed(AppRoutes.loanRequestStart);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Widget _buildItem(String? path, String label, VoidCallback onEdit) {
    if (path == null) return const SizedBox.shrink();
    return ListTile(
      leading: Image.file(File(path), width: 80, height: 80, fit: BoxFit.cover),
      title: Text(label),
      trailing: TextButton(onPressed: onEdit, child: const Text('Editar')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loanRequestProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('Revisión')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildItem(state.cardFront, 'Tarjeta', () => Get.toNamed(AppRoutes.loanCaptureCard)),
                _buildItem(state.ineFront, 'INE Frente', () => Get.toNamed(AppRoutes.loanCaptureIneFront)),
                _buildItem(state.ineBack, 'INE Reverso', () => Get.toNamed(AppRoutes.loanCaptureIneBack)),
                _buildItem(state.docPhoto, 'Documento', () => Get.toNamed(AppRoutes.loanCaptureDoc)),
                _buildItem(state.signaturePngPath, 'Firma', () => Get.toNamed(AppRoutes.loanSign)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state.isComplete && !_sending ? _submit : null,
                  child: const Text('Enviar solicitud'),
                ),
              ],
            ),
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
        ),
        if (_sending)
          Container(
            color: Colors.black45,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}


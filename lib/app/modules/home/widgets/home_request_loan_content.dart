import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'loan_camera_page.dart';

class HomeRequestLoanContent extends StatefulWidget {
  final dynamic controller;
  const HomeRequestLoanContent({super.key, required this.controller});

  @override
  State<HomeRequestLoanContent> createState() => _HomeRequestLoanContentState();
}

class _HomeRequestLoanContentState extends State<HomeRequestLoanContent> {
  final loanAmountController = TextEditingController();
  String selectedTerm = '6 meses';

  final Map<LoanDocKind, XFile?> _photos = {
    for (var k in LoanDocKind.values) k: null,
  };
  final Map<LoanDocKind, Uint8List?> _photoBytes = {
    for (var k in LoanDocKind.values) k: null,
  };
  final Map<LoanDocKind, String?> _photoB64 = {
    for (var k in LoanDocKind.values) k: null,
  };

  bool get _allCaptured =>
      LoanDocKind.values.every((k) => _photos[k] != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Solicitar préstamo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Crédito disponible
          Container(
            decoration: BoxDecoration(
              color: theme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Crédito disponible',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: theme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '\$15,000.00',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tasa de interés',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: theme.onSurface,
                      ),
                    ),
                    Text(
                      '12.5%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Monto del préstamo
          Text(
            'Monto del préstamo',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  '\$',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              TextField(
                controller: loanAmountController,
                keyboardType: TextInputType.number,
                autofillHints: const [],
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: '0.00',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Mínimo: \$1,000.00 - Máximo: \$15,000.00',
            style: TextStyle(fontSize: 10, color: theme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Plazo
          Text(
            'Plazo',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: selectedTerm,
            items: ['3 meses', '6 meses', '9 meses', '12 meses']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => selectedTerm = val ?? selectedTerm),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildDocCard(LoanDocKind.ineFront),
          const SizedBox(height: 12),
          _buildDocCard(LoanDocKind.ineBack),
          const SizedBox(height: 12),
          _buildDocCard(LoanDocKind.comprobante),
          const SizedBox(height: 16),

          _buildSummary(theme),

          // Enviar solicitud
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.onPrimaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _allCaptured ? _submitLoan : null,
              child: Text(
                'Enviar solicitud',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: theme.primaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocCard(LoanDocKind kind) {
    final theme = Theme.of(context).colorScheme;
    final photo = _photos[kind];
    final bytes = _photoBytes[kind];
    final completed = photo != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kind.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.onSurface,
                  ),
                ),
                _buildBadge(completed),
              ],
            ),
            const SizedBox(height: 8),
            if (bytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  bytes,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
            else
              Text(
                kind.helper,
                style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _captureDoc(kind),
                  child: Text(completed ? 'Repetir' : 'Tomar'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: completed ? () => _removeDoc(kind) : null,
                  child: const Text('Quitar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(bool done) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: done ? theme.secondaryContainer : theme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        done ? 'Completado' : 'Pendiente',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: done ? theme.onSecondaryContainer : theme.onErrorContainer,
        ),
      ),
    );
  }

  Widget _buildSummary(ColorScheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen del préstamo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: theme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _summaryRow('Monto solicitado', '\$10,000.00'),
          _summaryRow('Tasa de interés', '12.5%'),
          _summaryRow('Plazo', selectedTerm),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pago mensual estimado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.onSurface,
                ),
              ),
              Text(
                '\$1,791.67',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.onSurface,
                ),
              ),
            ],
          ),
          for (final kind in LoanDocKind.values)
            if (_photoBytes[kind] != null) ...[
              const SizedBox(height: 12),
              Text(
                kind.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      _photoBytes[kind]!,
                      width: 96,
                      height: 96,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _photos[kind]!.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ],
        ],
      ),
    );
  }

  Future<void> _captureDoc(LoanDocKind kind) async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se requiere permiso de cámara')),
        );
      }
      return;
    }

    final photo = await Navigator.push<XFile?>(
      context,
      MaterialPageRoute(builder: (_) => LoanCameraPage(kind: kind)),
    );

    if (!mounted || photo == null) return;

    final bytes = await photo.readAsBytes();
    setState(() {
      _photos[kind] = photo;
      _photoBytes[kind] = bytes;
      _photoB64[kind] = base64Encode(bytes);
    });
  }

  void _removeDoc(LoanDocKind kind) {
    setState(() {
      _photos[kind] = null;
      _photoBytes[kind] = null;
      _photoB64[kind] = null;
    });
  }

  void _submitLoan() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitud enviada')),
    );
  }

  Widget _summaryRow(String label, String value) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 12, color: theme.onSurface),
          ),
        ],
      ),
    );
  }
}
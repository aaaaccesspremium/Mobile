import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // Para XFile
import 'loan_camera_page.dart'; // <-- ajusta la ruta si la guardas en otro folder
import 'package:permission_handler/permission_handler.dart';

class HomeRequestLoanContent extends StatefulWidget {
  final dynamic controller;
  const HomeRequestLoanContent({super.key, required this.controller});

  @override
  State<HomeRequestLoanContent> createState() => _HomeRequestLoanContentState();
}

class _HomeRequestLoanContentState extends State<HomeRequestLoanContent> {
  final loanAmountController = TextEditingController();
  String selectedTerm = "6 meses";

  // NUEVO: foto capturada
  XFile? _loanPhoto;
  Uint8List? _loanPhotoBytes;
  String? _loanPhotoB64;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Solicitar préstamo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 16),

          // Crédito disponible
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Crédito disponible",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    Text("\$15,000.00",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tasa de interés",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
                    Text("12.5%",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),
              ],
            ),
          ),

          // Monto del préstamo
          Text("Monto del préstamo",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 4),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text("\$",
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
              TextField(
                controller: loanAmountController,
                keyboardType: TextInputType.number,
                autofillHints: const [], // ← desactiva autofill para este campo
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: "0.00",
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text("Mínimo: \$1,000.00 - Máximo: \$15,000.00",
              style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),

          // Plazo
          Text("Plazo",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: selectedTerm,
            items: ["3 meses", "6 meses", "9 meses", "12 meses"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedTerm = val!;
              });
            },
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          // Resumen préstamo
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
              ],
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Resumen del préstamo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 8),
                _summaryRow("Monto solicitado", "\$10,000.00"),
                _summaryRow("Tasa de interés", "12.5%"),
                _summaryRow("Plazo", selectedTerm),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pago mensual estimado",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    Text("\$1,791.67",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  ],
                ),

                // NUEVO: miniatura si hay foto
                if (_loanPhotoBytes != null) ...[
                  const SizedBox(height: 12),
                  Text("Documento capturado",
                      style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _loanPhotoBytes!,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _loanPhoto?.name ?? 'imagen.jpg',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Quitar',
                        onPressed: () {
                          setState(() {
                            _loanPhoto = null;
                            _loanPhotoBytes = null;
                            _loanPhotoB64 = null;
                          });
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Botón -> abre cámara
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _onRequestLoanPressed,
              child: Text("Solicitar préstamo",
                  style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primaryContainer)),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onRequestLoanPressed() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se requiere permiso de cámara')),
        );
      }
      return;
    }

    final photo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoanCameraPage()),
    );

    if (!mounted || photo == null) return;

    final bytes = await photo.readAsBytes();
    setState(() {
      _loanPhoto = photo;
      _loanPhotoBytes = bytes;
      _loanPhotoB64 = base64Encode(bytes);
    });
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
          Text(value, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}

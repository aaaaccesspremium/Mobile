import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class HomeTransferContent extends StatelessWidget {
  final dynamic controller;

  const HomeTransferContent({super.key, required this.controller});

  final String clabe = "0123 4567 8901 2345 6789";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text("Transferir fondos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 16),

          // CLABE para depósitos
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tu CLABE para depósitos",
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(clabe,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.copy,
                          color: Theme.of(context).colorScheme.primaryContainer),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: clabe));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("CLABE copiada")),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),

          // Información transferencia
          Text("Información para transferencia",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
              ],
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoItem(context, "Banco", "BBVA México"),
                _infoItem(context, "Beneficiario", "Jazmín Pérez López"),
                _infoItem(context, "CLABE", clabe),
              ],
            ),
          ),

          // Instrucciones
          Text("Instrucciones",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text("1. Realiza una transferencia desde tu banca en línea o app móvil",
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                SizedBox(height: 4),
                Text("2. Usa la CLABE proporcionada",
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                SizedBox(height: 4),
                Text("3. El monto se reflejará en tu cuenta en 1-2 horas hábiles",
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                SizedBox(height: 4),
                Text("4. Guarda el comprobante de transferencia",
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}

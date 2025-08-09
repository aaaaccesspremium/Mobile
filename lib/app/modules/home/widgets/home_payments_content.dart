import 'package:flutter/material.dart';

class HomePaymentsContent extends StatelessWidget {
  final dynamic controller;

  const HomePaymentsContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
            "Tus pagos",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            ),
          const SizedBox(height: 16),

          // Historial de pagos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text("Historial de pagos",
                  style: 
                  TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,)),
              TextButton(
                onPressed: () {
                  // Acción para ver todos los pagos
                },
                child: Text("Ver todos",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              )
            ],
          ),
          const SizedBox(height: 8),
          Column(
            children: [
              _paymentItem(context, "Pago #12345", "12/05/2023", "\$1,250.00"),
              const SizedBox(height: 8),
              _paymentItem(context, "Pago #12344", "15/04/2023", "\$1,250.00"),
              const SizedBox(height: 8),
              _paymentItem(context, "Pago #12343", "15/03/2023", "\$1,250.00"),
            ],
          ),
          const SizedBox(height: 24),

          // Próximos pagos
          const Text("Próximos pagos",
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              border: Border.all(color: Theme.of(context).colorScheme.primaryFixed),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Pago programado",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Text("\$1,250.00",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryFixed))
                  ],
                ),
                const SizedBox(height: 4),
                Text("Fecha: 15/06/2023",
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // Acción de pagar ahora
                    },
                    child: Text("Pagar ahora",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _paymentItem(BuildContext context, String title, String date, String amount) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.primaryFixed),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
              Text(date, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onInverseSurface))
            ],
          ),
          Text(amount,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary))
        ],
      ),
    );
  }
}

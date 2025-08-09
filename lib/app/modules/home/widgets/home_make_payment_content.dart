import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeMakePaymentContent extends StatefulWidget {
  final dynamic controller;

  const HomeMakePaymentContent({super.key, required this.controller});

  @override
  State<HomeMakePaymentContent> createState() => _HomeMakePaymentContentState();
}

class _HomeMakePaymentContentState extends State<HomeMakePaymentContent> {
  final amountController = TextEditingController();
  String paymentMethod = 'card';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Realizar pago",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),

          // Resumen de saldo
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
                    Text("Saldo pendiente",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    Text("\$7,500.00",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text("Próximo pago mínimo",
                        style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    Text("\$1,250.00",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
              ],
            ),
          ),

          // Monto a pagar
          Text("Monto a pagar",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 4),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text("\$",
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16)),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  hintText: "0.00",
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Método de pago
          Text("Método de pago",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 8),
          Column(
            children: [
              _paymentMethodTile(
                value: 'card',
                title: "Tarjeta de crédito/débito",
                subtitle: "•••• •••• •••• 1234",
                icon: FontAwesomeIcons.creditCard,
              ),
              const SizedBox(height: 8),
                _paymentMethodTile(
                value: 'transfer',
                title: "Transferencia bancaria",
                subtitle: "CLABE: •••• •••• •••• •••• 7890",
                icon: FontAwesomeIcons.arrowsRotate,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Botón confirmar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // Acción para confirmar pago
              },
              child: Text("Confirmar pago",
                  style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary)),
            ),
          )
        ],
      ),
    );
  }

  Widget _paymentMethodTile({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          paymentMethod = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onPrimary), //esaul),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: paymentMethod,
              onChanged: (val) {
                setState(() {
                  paymentMethod = val!;
                });
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
                  Text(subtitle,
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            FaIcon(icon, color: Theme.of(context).colorScheme.primaryContainer)
          ],
        ),
      ),
    );
  }
}

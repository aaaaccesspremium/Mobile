import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeMainContent extends StatelessWidget {
  final dynamic controller;

  const HomeMainContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta crédito disponible
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.onPrimaryContainer],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tu crédito",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                     Text("\$15,000.00",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 4),
                    Text("MXN",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primaryFixed, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Límite total",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primaryFixed, fontSize: 12)),
                         Text("\$25,000.00",
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 14)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tasa de interés",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primaryFixed, fontSize: 12)),
                        Text("12.5%",
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 14)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Botones
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Theme.of(context).colorScheme.primaryFixed),
                    ),
                  ),
                  onPressed: () {
                    // Acción de solicitar préstamo
                    controller.changeTab(11);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        child: FaIcon(FontAwesomeIcons.handHoldingDollar,
                          color: Theme.of(context).colorScheme.primaryContainer),
                      ),
                      const SizedBox(height: 8),
                      const Text("Solicitar préstamo",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Theme.of(context).colorScheme.primaryFixed),
                    ),
                  ),
                  onPressed: () {
                    // Acción de realizar pago
                    controller.changeTab(10);
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                        child: FaIcon(FontAwesomeIcons.moneyBillWave,
                            color: Theme.of(context).colorScheme.primaryContainer),
                      ),
                      const SizedBox(height: 8),
                      const Text("Realizar pago",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Próximos pagos
            Text(
            "Próximos pagos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color:Theme.of(context).colorScheme.primaryContainer, blurRadius: 2, offset: Offset(0, 1))
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pago mensual",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Text("Próximo pago: 15/06/2023",
                            style:
                                TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      ],
                    ),
                    Text("\$1,250.00",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer))
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.onPrimary, //esaul
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Oportunidades
          const Text("Oportunidades",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade500, Colors.green.shade600],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("¡Aumenta tu límite!",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Calificas para un aumento de \$5,000",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    // Acción para ver oportunidad
                  },
                  child: const Text("Ver", style: TextStyle(fontSize: 12)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

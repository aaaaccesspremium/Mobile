import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../auth_controller.dart';

class LoginView extends StatelessWidget {
  final controller = Get.find<AuthController>();
  final tokenController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface,
                  blurRadius: 8,
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  "CrediApp",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Accede con tu código SMS",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Hemos enviado un código a tu celular *******123.\n"
                  "Si no tienes acceso, comunícate con tu SOFOM para realizar el cambio.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: tokenController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(FontAwesomeIcons.key),
                    labelText: "Código SMS (6 dígitos)",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    counterText: "", // oculta contador de caracteres
                  ),
                  onChanged: (value) {
                    if (value.length == 6) {
                      // Validar token cuando se ingresen los 6 dígitos
                      controller.validateToken(value);
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (tokenController.text.length == 6) {
                      controller.validateToken(tokenController.text);
                    } else {
                      Get.snackbar('Error', 'El código debe tener 6 dígitos');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Validar código",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

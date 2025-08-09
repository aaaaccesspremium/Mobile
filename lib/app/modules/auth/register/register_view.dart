import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sofomcloud_mobile/app/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../auth_controller.dart';

class RegisterView extends StatelessWidget {
  final controller = Get.find<AuthController>();
  final uuidController = TextEditingController();
  final birthDateController = TextEditingController();
  final emailController = TextEditingController();
  final termsAccepted = false.obs;

  RegisterView({super.key});

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
                Text(
                  "Crea tu cuenta",
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: uuidController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(FontAwesomeIcons.fingerprint),
                    labelText: "UUID",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: birthDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(FontAwesomeIcons.calendar),
                    labelText: "Fecha de nacimiento",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000, 1, 1),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      birthDateController.text =
                          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(FontAwesomeIcons.envelope),
                    labelText: "Correo electrónico",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() => CheckboxListTile(
                  value: termsAccepted.value,
                  onChanged: (val) => termsAccepted.value = val ?? false,
                  title: GestureDetector(
                  onTap: () {
                    // Reemplaza la URL con la de tus términos y condiciones
                    launchUrl(Uri.parse('https://www.google.com/?hl=es-419'));
                  },
                  child: const Text(
                    "Acepto los Términos y Condiciones",
                    style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    ),
                  ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                    onPressed: () {
                    if (!termsAccepted.value) {
                      Get.snackbar('Error', 'Debes aceptar los términos y condiciones');
                      return;
                    }
                    controller.register(
                      uuidController.text,
                      birthDateController.text,
                      emailController.text,
                    );
                    },
                    child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "Registrarse",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    ),
                  ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  child: const Text("¿Ya tienes una cuenta? Inicia sesión"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

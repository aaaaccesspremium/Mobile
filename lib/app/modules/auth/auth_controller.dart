import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final box = GetStorage();

void validateToken(String token) {
  if (token == "123456") { // Aquí iría tu lógica real de validación
    Get.snackbar('Éxito', 'Código válido');
    Get.offNamed(AppRoutes.home);
  } else {
    Get.snackbar('Error', 'Código inválido');
  }
}


  void register(String uuid, String birthDate, String email) {
    if (uuid.isEmpty || birthDate.isEmpty || email.isEmpty) {
      Get.snackbar('Error', 'Por favor completa todos los campos');
      return;
    }

    // Guarda los datos básicos en el storage
    box.write('user', {
      'uuid': uuid,
      'birthDate': birthDate,
      'email': email,
    });

    Get.snackbar('Éxito', 'Registro exitoso. Ahora puedes iniciar sesión.');
    Get.offNamed(AppRoutes.login);
  }
}

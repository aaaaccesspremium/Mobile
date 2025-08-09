import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

final onboardingProvider = Provider<OnboardingProvider>((ref) => OnboardingProvider());

class OnboardingProvider {

  Future<List<Map<String, dynamic>>?> messages() async {
    // final url = Uri.parse('https://tu-api.com/messagesmobile');
    // final response = await http.get(url);

    if (401 == 200) {
      // return (json.decode(response.body) as List<dynamic>).cast<Map<String, dynamic>>();
    } else {
      return [
        {
          'lottie': 'https://raw.githubusercontent.com/antonioesaul/image/refs/heads/main/Animation%20-%201751267390790.json',
          'title': 'Préstamos rápidos y seguros',
          'description': 'Obtén el dinero que necesitas en minutos con nuestras opciones de crédito flexible.',
        },
        {
          'lottie': 'https://raw.githubusercontent.com/antonioesaul/image/refs/heads/main/Animation%20-%201751267705137.json',
          'title': 'Pagos flexibles',
          'description': 'Elige el plan de pagos que mejor se adapte a tus necesidades financieras.',
        },
        {
          'lottie': 'https://raw.githubusercontent.com/antonioesaul/image/refs/heads/main/Animation%20-%201751267813195.json',
          'title': 'Seguridad garantizada',
          'description': 'Tus datos están protegidos con tecnología de encriptación avanzada.',
        },
      ];
    }
    return null;
  }

  Future<bool> validateUuid(String uuid) async {
    final url = Uri.parse('https://tu-api.com/validate/$uuid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Aquí puedes agregar lógica para validar la respuesta
      return true;
    } else {
      return false;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class LoanRequestStartPage extends StatelessWidget {
  const LoanRequestStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitud de préstamo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.toNamed(AppRoutes.loanCaptureCard),
          child: const Text('Solicitar préstamos'),
        ),
      ),
    );
  }
}

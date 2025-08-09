import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'auto_capture_screen.dart';
import 'loan_request_provider.dart';
import '../../routes/app_routes.dart';

class CaptureIneBackPage extends ConsumerWidget {
  const CaptureIneBackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoCaptureScreen(
      title: 'INE – Reverso',
      purpose: CapturePurpose.ineBack,
      nextRoute: AppRoutes.loanCaptureDoc,
      initialPath: ref.read(loanRequestProvider).ineBack,
      onSaved: (file) =>
          ref.read(loanRequestProvider.notifier).setIneBack(file.path),
    );
  }
}

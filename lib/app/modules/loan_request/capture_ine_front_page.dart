import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'auto_capture_screen.dart';
import 'loan_request_provider.dart';
import '../../routes/app_routes.dart';

class CaptureIneFrontPage extends ConsumerWidget {
  const CaptureIneFrontPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoCaptureScreen(
      title: 'INE – Frente',
      purpose: CapturePurpose.ineFront,
      nextRoute: AppRoutes.loanCaptureIneBack,
      initialPath: ref.read(loanRequestProvider).ineFront,
      onSaved: (file) =>
          ref.read(loanRequestProvider.notifier).setIneFront(file.path),
    );
  }
}

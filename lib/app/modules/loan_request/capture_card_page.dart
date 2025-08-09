import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'auto_capture_screen.dart';
import 'loan_request_provider.dart';
import '../../routes/app_routes.dart';

class CaptureCardPage extends ConsumerWidget {
  const CaptureCardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoCaptureScreen(
      title: 'Foto de tarjeta',
      purpose: CapturePurpose.cardFront,
      nextRoute: AppRoutes.loanCaptureIneFront,
      initialPath: ref.read(loanRequestProvider).cardFront,
      onSaved: (file) =>
          ref.read(loanRequestProvider.notifier).setCardFront(file.path),
    );
  }
}

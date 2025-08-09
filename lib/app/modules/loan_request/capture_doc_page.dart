import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'auto_capture_screen.dart';
import 'loan_request_provider.dart';
import '../../routes/app_routes.dart';

class CaptureDocPage extends ConsumerWidget {
  const CaptureDocPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoCaptureScreen(
      title: 'Foto de documento',
      purpose: CapturePurpose.docPhoto,
      nextRoute: AppRoutes.loanSign,
      initialPath: ref.read(loanRequestProvider).docPhoto,
      onSaved: (file) =>
          ref.read(loanRequestProvider.notifier).setDocPhoto(file.path),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:sofomcloud_mobile/app/core/theme/app_theme.dart';
import 'package:sofomcloud_mobile/app/data/models/loan_document.dart';
import 'package:sofomcloud_mobile/app/data/repositories/loan_document_repository.dart';
import 'package:sofomcloud_mobile/app/modules/loan_capture/controllers/loan_capture_controller.dart';
import 'package:sofomcloud_mobile/app/modules/loan_capture/views/loan_capture_view.dart';
import 'package:sofomcloud_mobile/app/services/permission_service.dart';

class _FakeLoanDocumentRepository implements LoanDocumentRepository {
  @override
  Future<List<LoanDocument>> fetchRequiredDocuments() async {
    return LoanDocumentType.values.map((type) => LoanDocument(type: type)).toList();
  }
}

class _FakePermissionService implements PermissionService {
  @override
  Future<bool> ensureCameraAccess() async => true;

  @override
  Future<bool> ensureMediaAccess() async => true;

  @override
  Future<void> openAppSettings() async {}
}

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('LoanCaptureView renders docs and enables action when completed',
      (tester) async {
    final controller = LoanCaptureController(
      repository: _FakeLoanDocumentRepository(),
      permissionService: _FakePermissionService(),
      captureFlow: (_) async => null,
    );

    Get.put(controller);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: const LoanCaptureView(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('INE - Frente'), findsOneWidget);
    final disabledButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Completa la captura'),
    );
    expect(disabledButton.onPressed, isNull);

    controller.markDocumentCaptured(LoanDocumentType.officialIdFront, '/tmp/front.jpg');
    controller.markDocumentCaptured(LoanDocumentType.officialIdBack, '/tmp/back.jpg');
    controller.markDocumentCaptured(LoanDocumentType.proofOfAddress, '/tmp/address.jpg');

    await tester.pump();

    expect(find.text('Continuar'), findsOneWidget);
  });
}

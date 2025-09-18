import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:sofomcloud_mobile/app/data/models/loan_document.dart';
import 'package:sofomcloud_mobile/app/data/repositories/loan_document_repository.dart';
import 'package:sofomcloud_mobile/app/modules/loan_capture/controllers/loan_capture_controller.dart';
import 'package:sofomcloud_mobile/app/services/permission_service.dart';

class _FakeLoanDocumentRepository implements LoanDocumentRepository {
  _FakeLoanDocumentRepository({this.documents});

  final List<LoanDocument>? documents;

  @override
  Future<List<LoanDocument>> fetchRequiredDocuments() async {
    return documents ??
        LoanDocumentType.values.map((type) => LoanDocument(type: type)).toList();
  }
}

class _FakePermissionService implements PermissionService {
  _FakePermissionService({this.cameraGranted = true, this.mediaGranted = true});

  bool cameraGranted;
  bool mediaGranted;

  @override
  Future<bool> ensureCameraAccess() async => cameraGranted;

  @override
  Future<bool> ensureMediaAccess() async => mediaGranted;

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

  test('loadDocuments fills the list and sets ready status', () async {
    final repository = _FakeLoanDocumentRepository();
    final permissions = _FakePermissionService();

    final controller = LoanCaptureController(
      repository: repository,
      permissionService: permissions,
      captureFlow: (_) async => null,
    );

    Get.put(controller);

    await controller.loadDocuments();

    expect(controller.documents.length, LoanDocumentType.values.length);
    expect(controller.status.value, LoanCaptureStatus.ready);
  });

  test('startCapture handles permission denied state', () async {
    final repository = _FakeLoanDocumentRepository();
    final permissions = _FakePermissionService(cameraGranted: false);

    final controller = LoanCaptureController(
      repository: repository,
      permissionService: permissions,
      captureFlow: (_) async => null,
    );

    Get.put(controller);

    await controller.loadDocuments();
    await controller.startCapture(LoanDocumentType.officialIdFront);

    expect(controller.status.value, LoanCaptureStatus.permissionDenied);
  });

  test('startCapture stores captured document when flow returns path', () async {
    final repository = _FakeLoanDocumentRepository();
    final permissions = _FakePermissionService();

    final controller = LoanCaptureController(
      repository: repository,
      permissionService: permissions,
      captureFlow: (_) async => '/tmp/document.jpg',
    );

    Get.put(controller);

    await controller.loadDocuments();
    await controller.startCapture(LoanDocumentType.officialIdFront);

    final document = controller.documents
        .firstWhere((doc) => doc.type == LoanDocumentType.officialIdFront);
    expect(document.isCompleted, isTrue);
    expect(controller.status.value, LoanCaptureStatus.ready);
  });
}

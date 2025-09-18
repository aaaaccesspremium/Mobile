import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/models/loan_document.dart';
import '../../../data/repositories/loan_document_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/permission_service.dart';

enum LoanCaptureStatus {
  loading,
  ready,
  empty,
  capturing,
  permissionDenied,
  error,
}

class LoanCaptureController extends GetxController {
  LoanCaptureController({
    required LoanDocumentRepository repository,
    required PermissionService permissionService,
    Future<String?> Function(LoanDocumentType type)? captureFlow,
  })  : _repository = repository,
        _permissionService = permissionService,
        _captureFlow = captureFlow ??
            ((type) => Get.toNamed<String>(
                  AppRoutes.loanCaptureCamera,
                  arguments: type,
                ));

  final LoanDocumentRepository _repository;
  final PermissionService _permissionService;
  final Future<String?> Function(LoanDocumentType type) _captureFlow;

  final RxList<LoanDocument> documents = <LoanDocument>[].obs;
  final Rx<LoanCaptureStatus> status = LoanCaptureStatus.loading.obs;
  final RxnString errorMessage = RxnString();

  bool get isReadyToSubmit =>
      documents.isNotEmpty && documents.every((doc) => doc.isCompleted);

  @override
  void onInit() {
    super.onInit();
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    status.value = LoanCaptureStatus.loading;
    errorMessage.value = null;
    try {
      final result = await _repository.fetchRequiredDocuments();
      documents.assignAll(result);
      status.value =
          result.isEmpty ? LoanCaptureStatus.empty : LoanCaptureStatus.ready;
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'loan_capture',
        ),
      );
      errorMessage.value =
          'No pudimos cargar los documentos. Intenta nuevamente.';
      status.value = LoanCaptureStatus.error;
    }
  }

  Future<void> startCapture(LoanDocumentType type) async {
    errorMessage.value = null;
    final hasCamera = await _permissionService.ensureCameraAccess();
    if (!hasCamera) {
      status.value = LoanCaptureStatus.permissionDenied;
      return;
    }

    final hasMedia = await _permissionService.ensureMediaAccess();
    if (!hasMedia) {
      status.value = LoanCaptureStatus.permissionDenied;
      return;
    }

    status.value = LoanCaptureStatus.capturing;
    final result = await _captureFlow(type);
    if (result != null && result.isNotEmpty) {
      markDocumentCaptured(type, result);
    }
    status.value = documents.isEmpty
        ? LoanCaptureStatus.empty
        : LoanCaptureStatus.ready;
  }

  void markDocumentCaptured(LoanDocumentType type, String path) {
    for (var index = 0; index < documents.length; index++) {
      final document = documents[index];
      if (document.type == type) {
        documents[index] = document.copyWith(
          filePath: path,
          capturedAt: DateTime.now(),
        );
        documents.refresh();
        break;
      }
    }
  }

  void resetPermissionWarning() {
    status.value =
        documents.isEmpty ? LoanCaptureStatus.empty : LoanCaptureStatus.ready;
  }

  Future<void> openSettings() => _permissionService.openAppSettings();

  Future<void> finishCapture() async {
    Get.back<List<LoanDocument>>(result: documents.toList(growable: false));
  }
}

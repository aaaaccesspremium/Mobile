import 'package:get/get.dart';

import '../../../data/repositories/loan_document_repository.dart';
import '../../../services/permission_service.dart';
import '../controllers/loan_capture_controller.dart';

class LoanCaptureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoanDocumentRepository>(() => const LocalLoanDocumentRepository());
    Get.lazyPut<PermissionService>(() => DevicePermissionService());
    Get.put(
      LoanCaptureController(
        repository: Get.find<LoanDocumentRepository>(),
        permissionService: Get.find<PermissionService>(),
      ),
    );
  }
}

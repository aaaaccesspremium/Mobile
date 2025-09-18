import 'package:get/get.dart';

import '../../../data/models/loan_document.dart';

class HomeController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxList<LoanDocument> capturedDocuments = <LoanDocument>[].obs;

  @override
  void onInit() {
    super.onInit();
    capturedDocuments.assignAll(
      LoanDocumentType.values.map((type) => LoanDocument(type: type)),
    );
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> onDocumentsCaptured(List<LoanDocument> documents) async {
    for (final document in documents) {
      final index = capturedDocuments
          .indexWhere((element) => element.type == document.type);
      if (index >= 0) {
        capturedDocuments[index] = document;
      } else {
        capturedDocuments.add(document);
      }
    }
    capturedDocuments.refresh();
    Get.snackbar(
      'Documentos listos',
      'Tus archivos se guardaron correctamente.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void submitLoanRequest() {
    final pending = capturedDocuments
        .where((doc) => !doc.isCompleted)
        .toList(growable: false);

    if (pending.isNotEmpty) {
      Get.snackbar(
        'Faltan documentos',
        'Completa la captura de ${pending.length} documento(s).',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      'Solicitud enviada',
      'Enviaremos un seguimiento cuando terminemos la validación.',
      snackPosition: SnackPosition.BOTTOM,
    );
    changeTab(0);
  }
}

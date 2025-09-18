import '../models/loan_document.dart';

abstract class LoanDocumentRepository {
  Future<List<LoanDocument>> fetchRequiredDocuments();
}

class LocalLoanDocumentRepository implements LoanDocumentRepository {
  const LocalLoanDocumentRepository();

  @override
  Future<List<LoanDocument>> fetchRequiredDocuments() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return LoanDocumentType.values
        .map((type) => LoanDocument(type: type))
        .toList(growable: false);
  }
}

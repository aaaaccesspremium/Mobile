import 'package:flutter/material.dart';

enum LoanDocumentType { officialIdFront, officialIdBack, proofOfAddress }

extension LoanDocumentTypeX on LoanDocumentType {
  String get title {
    switch (this) {
      case LoanDocumentType.officialIdFront:
        return 'INE - Frente';
      case LoanDocumentType.officialIdBack:
        return 'INE - Reverso';
      case LoanDocumentType.proofOfAddress:
        return 'Comprobante de domicilio';
    }
  }

  String get helper {
    switch (this) {
      case LoanDocumentType.officialIdFront:
        return 'Coloca el frente de tu identificación dentro del marco.';
      case LoanDocumentType.officialIdBack:
        return 'Captura el reverso sin reflejos ni sombras.';
      case LoanDocumentType.proofOfAddress:
        return 'Asegúrate de que el documento sea legible y vigente.';
    }
  }

  IconData get icon {
    switch (this) {
      case LoanDocumentType.officialIdFront:
        return Icons.badge_outlined;
      case LoanDocumentType.officialIdBack:
        return Icons.credit_card;
      case LoanDocumentType.proofOfAddress:
        return Icons.description_outlined;
    }
  }

  double get aspectRatio {
    switch (this) {
      case LoanDocumentType.officialIdFront:
      case LoanDocumentType.officialIdBack:
        return 1.586;
      case LoanDocumentType.proofOfAddress:
        return 1.414;
    }
  }
}

class LoanDocument {
  const LoanDocument({
    required this.type,
    this.filePath,
    this.capturedAt,
  });

  final LoanDocumentType type;
  final String? filePath;
  final DateTime? capturedAt;

  bool get isCompleted => filePath != null && filePath!.isNotEmpty;

  LoanDocument copyWith({
    String? filePath,
    DateTime? capturedAt,
    bool clear = false,
  }) {
    return LoanDocument(
      type: type,
      filePath: clear ? null : filePath ?? this.filePath,
      capturedAt: clear ? null : capturedAt ?? this.capturedAt,
    );
  }
}

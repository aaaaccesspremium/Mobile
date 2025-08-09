import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanRequestState {
  final String? cardFront;
  final String? ineFront;
  final String? ineBack;
  final String? docPhoto;
  final String? signaturePngPath;

  const LoanRequestState({
    this.cardFront,
    this.ineFront,
    this.ineBack,
    this.docPhoto,
    this.signaturePngPath,
  });

  bool get isComplete =>
      cardFront != null &&
      cardFront!.isNotEmpty &&
      ineFront != null &&
      ineFront!.isNotEmpty &&
      ineBack != null &&
      ineBack!.isNotEmpty &&
      docPhoto != null &&
      docPhoto!.isNotEmpty &&
      signaturePngPath != null &&
      signaturePngPath!.isNotEmpty;

  LoanRequestState copyWith({
    String? cardFront,
    String? ineFront,
    String? ineBack,
    String? docPhoto,
    String? signaturePngPath,
  }) {
    return LoanRequestState(
      cardFront: cardFront ?? this.cardFront,
      ineFront: ineFront ?? this.ineFront,
      ineBack: ineBack ?? this.ineBack,
      docPhoto: docPhoto ?? this.docPhoto,
      signaturePngPath: signaturePngPath ?? this.signaturePngPath,
    );
  }
}

class LoanRequestNotifier extends StateNotifier<LoanRequestState> {
  LoanRequestNotifier() : super(const LoanRequestState()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = LoanRequestState(
      cardFront: prefs.getString('cardFront'),
      ineFront: prefs.getString('ineFront'),
      ineBack: prefs.getString('ineBack'),
      docPhoto: prefs.getString('docPhoto'),
      signaturePngPath: prefs.getString('signaturePng'),
    );
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    Future<void> save(String key, String? value) async {
      if (value == null || value.isEmpty) {
        await prefs.remove(key);
      } else {
        await prefs.setString(key, value);
      }
    }

    await save('cardFront', state.cardFront);
    await save('ineFront', state.ineFront);
    await save('ineBack', state.ineBack);
    await save('docPhoto', state.docPhoto);
    await save('signaturePng', state.signaturePngPath);
  }

  void setCardFront(String path) {
    state = state.copyWith(cardFront: path);
    _persist();
  }

  void setIneFront(String path) {
    state = state.copyWith(ineFront: path);
    _persist();
  }

  void setIneBack(String path) {
    state = state.copyWith(ineBack: path);
    _persist();
  }

  void setDocPhoto(String path) {
    state = state.copyWith(docPhoto: path);
    _persist();
  }

  void setSignaturePath(String path) {
    state = state.copyWith(signaturePngPath: path);
    _persist();
  }

  void clearSignature() {
    state = state.copyWith(signaturePngPath: null);
    _persist();
  }

  void clear() {
    state = const LoanRequestState();
    _persist();
  }
}

final loanRequestProvider =
    StateNotifierProvider<LoanRequestNotifier, LoanRequestState>(
        (ref) => LoanRequestNotifier());

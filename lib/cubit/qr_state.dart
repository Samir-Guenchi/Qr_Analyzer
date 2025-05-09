abstract class QrState {}

class QrInitial extends QrState {}

class QrAnalyzing extends QrState {}

class QrValid extends QrState {}

class QrInvalid extends QrState {}

class QrError extends QrState {
  final String message;

  QrError({required this.message});
}

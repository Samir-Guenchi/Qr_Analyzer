import 'package:equatable/equatable.dart';

abstract class QrState extends Equatable {
  const QrState();

  @override
  List<Object> get props => [];
}

class QrInitial extends QrState {}

class QrAnalyzing extends QrState {}

class QrValid extends QrState {}

class QrInvalid extends QrState {}

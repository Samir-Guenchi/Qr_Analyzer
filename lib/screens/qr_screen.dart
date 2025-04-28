import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/cubit/qr_cubit.dart';
import 'package:qrcode/widgets/header.dart';
import '../cubit/qr_state.dart';
import 'validurl.dart';
import 'non_validurl.dart';
import 'inprogress.dart';

class QrScreen extends StatelessWidget {
  final String scannedUrl;

  const QrScreen({super.key, required this.scannedUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QrCubit()..analyzeUrl(scannedUrl),
      child: BlocBuilder<QrCubit, QrState>(
        builder: (context, state) {
          if (state is QrAnalyzing) return const AnalyzingPage();
          if (state is QrValid) return const ResultValidPage();
          if (state is QrInvalid) return const ResultInvalidPage();
          return const SizedBox(); 
        },
      ),
    );
  }
}

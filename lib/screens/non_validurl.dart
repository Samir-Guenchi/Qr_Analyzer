import 'package:flutter/material.dart';
import 'package:qrcode/widgets/header.dart';
import 'package:qrcode/widgets/footer.dart';

class ResultInvalidPage extends StatelessWidget {
  const ResultInvalidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AnalyzingHeader(title: "Results"),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Analysis result:\nURL is invalid",
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                
              ],
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}
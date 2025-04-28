import 'package:flutter/material.dart';
import 'package:qrcode/widgets/header.dart';
import 'package:qrcode/widgets/footer.dart';

class ResultValidPage extends StatelessWidget {
  const ResultValidPage({super.key});

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
                  "Analysis result:\nURL is valid",
                  style: TextStyle(color: Colors.teal),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
              ],
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}
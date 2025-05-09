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
          // Header
          const AnalyzingHeader(title: "Results"),

          // Main content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: 100,
                  color: Colors.red,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Analysis result:\nURL is invalid",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
              ],
            ),
          ),

          // Footer
          const FooterWidget(),
        ],
      ),
    );
  }
}

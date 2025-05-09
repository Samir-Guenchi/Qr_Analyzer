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
          // Header
          const AnalyzingHeader(title: "Results"),

          // Main content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 100,
                  color: Colors.teal,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Analysis result:\nURL is valid",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
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

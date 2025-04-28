import 'package:flutter/material.dart';
import 'package:qrcode/widgets/header.dart';
import 'package:qrcode/widgets/footer.dart';

class AnalyzingPage extends StatelessWidget {
  const AnalyzingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AnalyzingHeader(title: "Analyzing"),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/inprogress.png', height: 100), 
                const SizedBox(height: 10),
                Text(
                    "We are analyzing your URL\nPlease wait...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [
                            Color(0xFF0AAEC7),  
                            Color(0xFF262D40),  
                          ],
                        ).createShader(Rect.fromLTWH(0, 0, 200, 100)), 
                    ),
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
// lib/screens/result_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanner_safe_flutter/screens/scanner_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:scanner_safe_flutter/widgets/footer.dart';

class ResultScreen extends StatelessWidget {
  final String url;
  final String? originalQrCode;
  final bool isSafe;
  final String message;

  const ResultScreen({
    Key? key,
    required this.url,
    this.originalQrCode,
    required this.isSafe,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define wave colors based on URL safety status
    final Color waveBaseColor = isSafe ? Colors.green.shade300 : Colors.red.shade300;
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top wave decoration with transform as in original code
            // Transform(
            //   alignment: Alignment.center,
            //   transform: Matrix4.identity()..scale(1.0, -1.0), // Flip vertically as requested
            //   child: WaveWidget(
            //     config: CustomConfig(
            //       gradients: [
            //         [waveBaseColor, waveBaseColor.withOpacity(0.8)],
            //         [waveBaseColor.withOpacity(0.8), waveBaseColor.withOpacity(0.7)],
            //         [waveBaseColor.withOpacity(0.7), waveBaseColor.withOpacity(0.6)],
            //         [waveBaseColor.withOpacity(0.6), waveBaseColor.withOpacity(0.5)],
            //       ],
            //       durations: [7000, 5000, 6000, 4000],
            //       heightPercentages: [0.20, 0.23, 0.25, 0.28], // Symmetric heights
            //       gradientBegin: Alignment.bottomLeft,
            //       gradientEnd: Alignment.topRight,
            //       blur: MaskFilter.blur(BlurStyle.solid, 5),
            //     ),
            //     backgroundColor: Colors.transparent,
            //     size: const Size(double.infinity, 50),
            //     waveAmplitude: 5,
            //   ),
            // ),
            
            Card(
              elevation: 4,
              color: isSafe ? Colors.green.shade50 : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      isSafe ? Icons.security : Icons.warning_amber_rounded,
                      size: 48,
                      color: isSafe ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isSafe ? 'Safe URL' : 'Potentially Unsafe URL',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSafe ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSafe ? Colors.green.shade900 : Colors.red.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // URL section
            const Text(
              'Detected URL:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      url,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: url));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('URL copied to clipboard')),
                      );
                    },
                    tooltip: 'Copy URL',
                  ),
                ],
              ),
            ),
            
            // Original QR code content (if different from URL)
            if (originalQrCode != null && originalQrCode != url) ...[
              const SizedBox(height: 16),
              const Text(
                'Original QR Content:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        originalQrCode!,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: originalQrCode!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Content copied to clipboard')),
                        );
                      },
                      tooltip: 'Copy content',
                    ),
                  ],
                ),
              ),
            ],
            
            const Spacer(),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan Again'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ScannerScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Open URL'),
                    onPressed: isSafe ? () => _launchUrl(url, context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSafe ? Colors.green : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // No need for explicit bottom wave widget as the FooterWidget 
            // already contains waves according to your description
            
            // Footer with waves
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url, BuildContext context) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid URL: $e')),
      );
    }
  }
}
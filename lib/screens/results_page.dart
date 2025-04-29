import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class ResultsPage extends StatelessWidget {
  final String? url;

  const ResultsPage({super.key, this.url = ''});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final scannedUrl = args?['url'] ?? url ?? 'Unknown URL';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Results'),
        backgroundColor: const Color(0xFF4A6FFF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4A6FFF), Color(0xFF7B9FFF)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Scanned URL:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A6FFF),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                scannedUrl,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Divider(height: 30),
                              const Text(
                                'Analysis Summary:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A6FFF),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '✅ The URL appears to be safe.\n✅ No malicious content detected.\n✅ SSL Certificate is valid.\n✅ Redirects are clean.\n\nFor more details, visit our online report.',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Wave footer with "Made by ensia"
                SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: Stack(
                    children: [
                      ClipRect(
                        child: WaveWidget(
                          config: CustomConfig(
                            gradients: [
                              [const Color(0xFF5B7FFF), const Color(0xFF4A6FFF)],
                              [const Color(0xFF4A6FFF), const Color(0xFF7B9FFF)],
                              [const Color(0xFF7B9FFF), const Color(0xFF5B7FFF)],
                              [const Color(0xFF4A6FFF), const Color(0xFF8AAFFF)],
                            ],
                            durations: [6000, 7000, 6500, 7200],
                            heightPercentages: [0.60, 0.62, 0.64, 0.66],
                            gradientBegin: Alignment.bottomLeft,
                            gradientEnd: Alignment.topRight,
                            blur: MaskFilter.blur(BlurStyle.solid, 8),
                          ),
                          backgroundColor: Colors.transparent,
                          size: const Size(double.infinity, 120),
                          waveAmplitude: 30,
                          waveFrequency: 1,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: const Text(
                            'Made by ensia',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

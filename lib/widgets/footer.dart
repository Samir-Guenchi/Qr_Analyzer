import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200, // Increased height for more wave visibility
      child: Stack(
        children: [
          // Wave shape using wave package
          ClipRect(
            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [const Color(0xFF5B7FFF), const Color(0xFF4A6FFF)],
                  [const Color(0xFF4A6FFF), const Color(0xFF7B9FFF)],
                  [const Color(0xFF7B9FFF), const Color(0xFF5B7FFF)],
                  [const Color(0xFF4A6FFF), const Color(0xFF8AAFFF)],
                ],
                durations: [6000, 7000, 6500, 7200], // Slower wave movement
                heightPercentages: [0.60, 0.62, 0.64, 0.66],
                gradientBegin: Alignment.bottomLeft,
                gradientEnd: Alignment.topRight,
                blur: MaskFilter.blur(BlurStyle.solid, 8),
              ),
              backgroundColor: Colors.transparent,
              size: Size(double.infinity, 200),
              waveAmplitude: 30,
              waveFrequency: 1,
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Made by attribution text
                const Text(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
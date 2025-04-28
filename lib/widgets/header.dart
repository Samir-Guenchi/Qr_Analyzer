import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class AnalyzingHeader extends StatefulWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AnalyzingHeader({
    super.key, 
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  State<AnalyzingHeader> createState() => _AnalyzingHeaderState();
}

class _AnalyzingHeaderState extends State<AnalyzingHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140, // Slightly reduced height to balance with footer
      child: Stack(
        children: [
          // Wave shape using wave package - inverted for header
          Transform(
            // Flip the wave upside down for header
            alignment: Alignment.center,
            transform: Matrix4.rotationX(3.14159), // PI in radians (180 degrees)
            child: ClipRect(
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [const Color(0xFF4A6FFF), const Color(0xFF5B7FFF)],
                    [const Color(0xFF5B7FFF), const Color(0xFF4A6FFF)],
                  ],
                  durations: [4000, 5000],
                  heightPercentages: [0.65, 0.66],
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                backgroundColor: Colors.transparent,
                size: Size(double.infinity, 140),
                waveAmplitude: 0,
              ),
            ),
          ),
          
          // Content with back button option
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.showBackButton)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: widget.onBackPressed ?? () => Navigator.of(context).pop(),
                    ),
                  ),
                
                Expanded(
                  child: Center(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                
                // Balance space for back button
                if (widget.showBackButton)
                  const SizedBox(width: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:scanner_safe_flutter/screens/scanner_screen.dart';
import 'package:scanner_safe_flutter/widgets/footer.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.02),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // WaveWidget with reduced height
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(1.0, -1.0), // Flip vertically
                child: WaveWidget(
                  config: CustomConfig(
                    gradients: [
                      [const Color(0xFF5B7FFF), const Color(0xFF4A6FFF)],
                      [const Color(0xFF4A6FFF), const Color(0xFF7B9FFF)],
                      [const Color(0xFF7B9FFF), const Color(0xFF5B7FFF)],
                      [const Color(0xFF4A6FFF), const Color(0xFF8AAFFF)],
                    ],
                    durations: [7000, 5000, 6000, 4000],
                    heightPercentages: [0.20, 0.23, 0.25, 0.28],
                    gradientBegin: Alignment.topLeft, // Adjusted for downward flow
                    gradientEnd: Alignment.bottomRight, // Adjusted for downward flow
                    blur: MaskFilter.blur(BlurStyle.solid, 5),
                  ),
                  backgroundColor: Colors.transparent,
                  size: const Size(double.infinity, 80), // Reduced height
                  waveAmplitude: 5,
                ),
              ),
              // Existing content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: [
                    SlideTransition(
                      position: _animation,
                      child: Image.asset(
                        'assets/home.png',
                        height: 220,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Scan QR codes to check if websites are safe',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This app will scan QR codes and verify if the\nlinked website is safe to visit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ScannerScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code),
                        label: const Text('Start Scanning'),
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          backgroundColor: Colors.indigoAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
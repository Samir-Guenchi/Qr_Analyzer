import 'package:flutter/material.dart';
import 'package:qrcode/widgets/foot_main.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Much faster animation
    )..repeat(reverse: true); // repeat animation up and down forever

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.02), // Smaller range but faster movement
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // smooth curve
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
      backgroundColor: Colors.white, // White background
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Add Header at the top of the screen
            // const AnalyzingHeader(title: 'Secure QR Scanner'),  // Header with title

            // Center content
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SlideTransition(
                        position: _animation,
                        child: Image.asset(
                          'assets/home.png',
                          height: 220, // Increased from 150 to 220
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Secure QR Scanner',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Detect and prevent malicious QR codes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Footer naturally at bottom
            const FooterWidget(),
          ],
        ),
      ),
    );
  }
}

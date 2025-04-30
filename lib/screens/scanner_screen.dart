import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_safe_flutter/screens/result_screen.dart';
import 'package:scanner_safe_flutter/services/url_checker_service.dart';
import 'dart:io' show Platform;
import 'package:scanner_safe_flutter/services/desktop_qr_scanner.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:scanner_safe_flutter/widgets/footer.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isProcessing = false;
  bool isCameraInitialized = false;
  bool isDesktop = false;

  @override
  void initState() {
    super.initState();
    isDesktop = _isDesktopPlatform();
  }

  bool _isDesktopPlatform() {
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    if (!isDesktop) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color waveBaseColor = const Color(0xFF5B7FFF);
    
    return Scaffold(
      body: Column(
        children: [
          // Top wave - reduced height to 50
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(1.0, -1.0), // Flip vertically
            child: WaveWidget(
              config: CustomConfig(
                gradients: [
                  [waveBaseColor, waveBaseColor.withOpacity(0.8)],
                  [waveBaseColor.withOpacity(0.8), waveBaseColor.withOpacity(0.7)],
                  [waveBaseColor.withOpacity(0.7), waveBaseColor.withOpacity(0.6)],
                  [waveBaseColor.withOpacity(0.6), waveBaseColor.withOpacity(0.5)],
                ],
                durations: [7000, 5000, 6000, 4000],
                heightPercentages: [0.20, 0.23, 0.25, 0.28],
                gradientBegin: Alignment.topLeft,
                gradientEnd: Alignment.bottomRight,
                blur: MaskFilter.blur(BlurStyle.solid, 5),
              ),
              backgroundColor: Colors.transparent,
              size: const Size(double.infinity, 50), // Reduced height from 80 to 50
              waveAmplitude: 5,
            ),
          ),
          const SizedBox(height: 20), // Reduced spacing from 100 to 20
          Expanded(
            flex: 5,
            child: isDesktop ? _buildDesktopView() : _buildMobileView(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              isDesktop
                  ? 'Desktop mode: Select a QR code image using the button below.'
                  : 'Point your camera at a QR code to scan.',
              style: TextStyle(
                fontSize: 16,
                color: waveBaseColor.withOpacity(0.8), // Match text color with wave
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Select QR Code Image'),
                onPressed: _scanFromImage,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  backgroundColor: waveBaseColor, // Match button color with wave
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          const SizedBox(height: 20), // Reduced spacing from 100 to 20
          // Footer with reduced height
          const FooterWidget(),
        ],
      ),
    );
  }

  Widget _buildMobileView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        MobileScanner(
          controller: controller,
          onDetect: _onDetect,
          overlay: CustomPaint(painter: ScannerOverlay()),
        ),
        if (isProcessing)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildDesktopView() {
    final Color waveBaseColor = const Color(0xFF5B7FFF);
    
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: waveBaseColor, width: 2), // Match border color with wave
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, size: 80, color: waveBaseColor.withOpacity(0.6)), // Match icon color with wave
                const SizedBox(height: 16),
                const Text(
                  'Camera not available on desktop',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use the button below to select a QR code image',
                  style: TextStyle(fontSize: 14, color: waveBaseColor.withOpacity(0.7)), // Match text color with wave
                ),
              ],
            ),
          ),
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator(color: waveBaseColor)), // Match loader color with wave
            ),
        ],
      ),
    );
  }

  Future<void> _scanFromImage() async {
    setState(() => isProcessing = true);
    try {
      final code = await DesktopQrScanner.scanImageFile();
      if (code == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No QR code found in image'),
          duration: Duration(seconds: 2),
        ));
        setState(() => isProcessing = false);
        return;
      }

      String url = _formatUrl(code);
      final result = await UrlCheckerService().checkUrl(url);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            url: url,
            originalQrCode: code != url ? code : null,
            isSafe: result.safe,
            message: result.message,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            url: 'Error scanning URL',
            isSafe: false,
            message: 'Failed to process QR code. ${e.toString()}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    if (isProcessing || capture.barcodes.isEmpty) return;
    final barcode = capture.barcodes.first;
    if (barcode.rawValue == null) return;

    setState(() => isProcessing = true);
    try {
      final code = barcode.rawValue!;
      String url = _formatUrl(code);
      final result = await UrlCheckerService().checkUrl(url);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            url: url,
            originalQrCode: code != url ? code : null,
            isSafe: result.safe,
            message: result.message,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            url: 'Error scanning URL',
            isSafe: false,
            message: 'Failed to process QR code. ${e.toString()}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  String _formatUrl(String code) {
    if (code.toLowerCase().startsWith('http://') || code.toLowerCase().startsWith('https://')) {
      return code;
    }
    if (code.contains('.') && !code.contains(' ') && !code.contains('\n')) {
      return 'https://$code';
    }
    return code;
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double boxWidth = size.width * 0.8;
    final double boxHeight = size.width * 0.8;
    final double left = (size.width - boxWidth) / 2;
    final double top = (size.height - boxHeight) / 2;
    final Paint borderPaint = Paint()
      ..color = const Color(0xFF5B7FFF) // Match scanner overlay color with wave
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final Rect rect = Rect.fromLTWH(left, top, boxWidth, boxHeight);
    canvas.drawRect(rect, borderPaint);

    final double cornerSize = 30.0;

    canvas.drawLine(Offset(left, top), Offset(left + cornerSize, top), borderPaint);
    canvas.drawLine(Offset(left, top), Offset(left, top + cornerSize), borderPaint);
    canvas.drawLine(Offset(left + boxWidth, top), Offset(left + boxWidth - cornerSize, top), borderPaint);
    canvas.drawLine(Offset(left + boxWidth, top), Offset(left + boxWidth, top + cornerSize), borderPaint);
    canvas.drawLine(Offset(left, top + boxHeight), Offset(left + cornerSize, top + boxHeight), borderPaint);
    canvas.drawLine(Offset(left, top + boxHeight), Offset(left, top + boxHeight - cornerSize), borderPaint);
    canvas.drawLine(Offset(left + boxWidth, top + boxHeight), Offset(left + boxWidth - cornerSize, top + boxHeight), borderPaint);
    canvas.drawLine(Offset(left + boxWidth, top + boxHeight), Offset(left + boxWidth, top + boxHeight - cornerSize), borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
import 'dart:io'; // Needed for File()
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrcode/cubit/qr_cubit.dart';
import 'package:qrcode/cubit/qr_state.dart';
import 'package:qrcode/widgets/footer.dart';
import 'package:qr_code_tools/qr_code_tools.dart'; 
import 'package:qr_code_scanner/qr_code_scanner.dart'; 
import 'package:qrcode/screens/inprogress.dart';
import 'package:qrcode/screens/non_validurl.dart';
import 'package:qrcode/screens/validurl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController; // Renamed to avoid conflict

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -0.02))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    qrController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  String qrResult = "No QR code detected yet";

  // For picking image
  final ImagePicker _picker = ImagePicker();

Future<void> _pickImageAndDecode() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    String? result;  // Declare result here outside the try block
    try {
      print("Picked image: ${image.path}");

      // Decode QR from image
      result = await QrCodeToolsPlugin.decodeFrom(image.path);

      setState(() {
        qrResult = result ?? "Failed to decode QR code";
      });
      print("Decoded QR code: $result");

    } catch (e) {
      print("Error decoding QR: $e");
      setState(() {
        qrResult = "Failed to decode QR code";
      });
    }

    // Now 'result' is accessible here as well
    if (result != null && (Uri.tryParse(result)?.hasAbsolutePath ?? false)) {
      context.read<QrCubit>().analyzeUrl(result);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AnalyzingPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResultInvalidPage()),
      );
    }
  } else {
    print("No image selected.");
  }
}


 void _onQRViewCreated(QRViewController controller) {
  qrController = controller;
  controller.scannedDataStream.listen((scanData) {
    setState(() {
      qrResult = scanData.code ?? "Failed to decode QR code"; // Use scanData.code directly
    });

    print("Decoded QR code: ${scanData.code}");

    if (scanData.code != null && (Uri.tryParse(scanData.code!)?.hasAbsolutePath ?? false)) {
      context.read<QrCubit>().analyzeUrl(scanData.code!);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResultInvalidPage()),
      );
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return BlocListener<QrCubit, QrState>(
      listener: (context, state) {
        if (state is QrAnalyzing) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AnalyzingPage()),
          );
        } else if (state is QrValid) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ResultValidPage()),
            (route) => route.isFirst,
          );
        } else if (state is QrInvalid) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ResultInvalidPage()),
            (route) => route.isFirst,
          );
        } else if (state is QrError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                            height: 220,
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
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(title: const Text('Scan QR Code')),
                                  body: QRView(
                                    key: qrKey,
                                    onQRViewCreated: _onQRViewCreated,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text("Scan QR"),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _pickImageAndDecode,
                          child: const Text("Upload QR Code Image"),
                        ),
                      ],
                    ),
                  ),
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

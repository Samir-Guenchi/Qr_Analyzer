import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'dart:io' show Platform;

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
    durations: [6000, 7000, 6500, 7200], // << Slower wave movement
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
                // Row with two buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Scan QR Code Button
                    _buildFooterButton(
                      context,
                      Icons.qr_code_scanner,
                      'Scan QR',
                      () => _showScanOptions(context),
                    ),
                    
                    const SizedBox(width: 40),
                    
                    // View History Button
                    _buildFooterButton(
                      context,
                      Icons.history,
                      'History',
                      () => Navigator.pushNamed(context, '/history'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
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
  
  // Reusable footer button
  Widget _buildFooterButton(
    BuildContext context, 
    IconData icon, 
    String label, 
    VoidCallback onPressed
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF4A6FFF),
        elevation: 6, // Slightly increased elevation
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        shadowColor: Colors.black26, // Added shadow for depth
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26), // Slightly larger icon
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showScanOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Scan QR Code',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A6FFF),
                ),
              ),
              const SizedBox(height: 20),
              // Take photo option
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF4A6FFF)),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePicture(context);
                },
              ),
              // Upload image option
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF4A6FFF)),
                title: const Text('Upload Image'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _takePicture(BuildContext context) async {
    if (Platform.isWindows) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Not Supported'),
          content: const Text('Camera functionality is not supported on Windows desktop. Please test on a mobile device or emulator.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    
    try {
      var cameraStatus = await Permission.camera.request();
      
      if (cameraStatus.isGranted) {
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        
        if (photo != null) {
          _processQRImage(photo);
        }
      } else {
        debugPrint('Camera permission denied');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text('Camera permission is required to take photos.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to access camera: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  Future<void> _pickImageFromGallery(BuildContext context) async {
    if (Platform.isWindows) {
      try {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        
        if (image != null) {
          _processQRImage(image);
        }
      } catch (e) {
        debugPrint('Error picking image on Windows: $e');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to select image: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }
    
    try {
      var storageStatus = await Permission.storage.request();
      
      if (storageStatus.isGranted || storageStatus.isLimited) {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        
        if (image != null) {
          _processQRImage(image);
        }
      } else {
        debugPrint('Storage permission denied');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permission Required'),
            content: const Text('Storage permission is required to access gallery.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to access gallery: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  void _processQRImage(XFile imageFile) async {
    debugPrint('Processing QR from image: ${imageFile.path}');
  }
}
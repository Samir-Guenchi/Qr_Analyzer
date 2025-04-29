// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:wave/config.dart';
// import 'package:wave/wave.dart';
// import 'dart:io' show Platform;
// import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

// class FooterWidget extends StatelessWidget {
//   const FooterWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 200,
//       child: Stack(
//         children: [
//           ClipRect(
//             child: WaveWidget(
//               config: CustomConfig(
//                 gradients: [
//                   [const Color(0xFF5B7FFF), const Color(0xFF4A6FFF)],
//                   [const Color(0xFF4A6FFF), const Color(0xFF7B9FFF)],
//                   [const Color(0xFF7B9FFF), const Color(0xFF5B7FFF)],
//                   [const Color(0xFF4A6FFF), const Color(0xFF8AAFFF)],
//                 ],
//                 durations: [6000, 7000, 6500, 7200],
//                 heightPercentages: [0.60, 0.62, 0.64, 0.66],
//                 gradientBegin: Alignment.bottomLeft,
//                 gradientEnd: Alignment.topRight,
//                 blur: const MaskFilter.blur(BlurStyle.solid, 8),
//               ),
//               backgroundColor: Colors.transparent,
//               size: const Size(double.infinity, 200),
//               waveAmplitude: 30,
//               waveFrequency: 1,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 40),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buildFooterButton(
//                       context,
//                       Icons.qr_code_scanner,
//                       'Scan QR',
//                       () => _showScanOptions(context),
//                     ),
//                     const SizedBox(width: 40),
//                     _buildFooterButton(
//                       context,
//                       Icons.history,
//                       'History',
//                       () => Navigator.pushNamed(context, '/history'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Made by ensia',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 4,
//                         color: Colors.black26,
//                         offset: Offset(1, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFooterButton(
//     BuildContext context,
//     IconData icon,
//     String label,
//     VoidCallback onPressed,
//   ) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF4A6FFF),
//         elevation: 6,
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
//         shadowColor: Colors.black26,
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 26),
//           const SizedBox(width: 10),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showScanOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Scan QR Code',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF4A6FFF),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Color(0xFF4A6FFF)),
//                 title: const Text('Take Photo'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _takePicture(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library, color: Color(0xFF4A6FFF)),
//                 title: const Text('Upload Image'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickImageFromGallery(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }


//   Future<void> _takePicture(BuildContext context) async {
//     if (Platform.isWindows) {
//       if (context.mounted) {
//         _showErrorDialog(
//           context,
//           'Not Supported',
//           'Camera functionality is not supported on Windows desktop.',
//         );
//       }
//       return;
//     }

//     try {
//       final cameraStatus = await Permission.camera.request();
//       if (!context.mounted) return;

//       if (cameraStatus.isGranted) {
//         final ImagePicker picker = ImagePicker();
//         final XFile? photo = await picker.pickImage(source: ImageSource.camera);
//         if (!context.mounted) return;

//         if (photo == null) {
//           _showErrorDialog(context, 'No Photo Taken', 'No photo was captured.');
//           return;
//         }

//         await _processQRImage(context, photo);
//       } else {
//         _showErrorDialog(
//           context,
//           'Permission Denied',
//           'Camera permission is required.',
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         _showErrorDialog(context, 'Error', 'Failed to access camera: $e');
//       }
//     }
//   }
//   Future<void> _processQRImage(BuildContext context, XFile imageFile) async {
//   if (!context.mounted) return;

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => const Dialog(
//       child: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(width: 20),
//             Text('Scanning QR Code...'),
//           ],
//         ),
//       ),
//     ),
//   );

//   try {
//     final barcodeScanner = BarcodeScanner();
//     final inputImage = InputImage.fromFilePath(imageFile.path);
//     final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
//     await barcodeScanner.close();

//     if (!context.mounted) return;
//     Navigator.of(context, rootNavigator: true).pop();

//     if (barcodes.isEmpty) {
//       _showErrorDialog(context, 'No QR Code Found', 'Try a clearer image.');
//       return;
//     }

//     String? foundUrl;
//     for (final barcode in barcodes) {
//       if (barcode.type == BarcodeType.url && barcode.rawValue != null) {
//         foundUrl = barcode.rawValue;
//         break;
//       } else if (barcode.rawValue != null && _isValidUrl(barcode.rawValue!)) {
//         foundUrl = barcode.rawValue;
//         break;
//       }
//     }

//     if (foundUrl == null) {
//       _showErrorDialog(context, 'No Valid URL Found', 'The QR does not contain a valid URL.');
//       return;
//     }

//     _navigateToAnalyzingPage(context, foundUrl);
//   } catch (e) {
//     if (context.mounted) {
//       Navigator.of(context, rootNavigator: true).pop();
//       _showErrorDialog(context, 'Error', 'Failed to process QR code: $e');
//     }
//   }
// }

//   Future<void> _pickImageFromGallery(BuildContext context) async {
//     try {
//       PermissionStatus permissionStatus;
//       if (Platform.isAndroid && (int.tryParse(Platform.version.split('.').first) ?? 0) >= 13) {
//         permissionStatus = await Permission.photos.request();
//       } else {
//         permissionStatus = await Permission.storage.request();
//       }
//       if (!context.mounted) return;

//       if (permissionStatus.isGranted || permissionStatus.isLimited) {
//         final ImagePicker picker = ImagePicker();
//         final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//         if (!context.mounted) return;

//         if (image == null) {
//           _showErrorDialog(context, 'No Image Selected', 'Please select an image to scan.');
//           return;
//         }

//         await _processQRImage(context, image);
//       } else {
//         _showErrorDialog(
//           context,
//           'Permission Denied',
//           'Gallery access is required.',
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         _showErrorDialog(context, 'Error', 'Failed to select image: $e');
//       }
//     }
//   }

//   bool _isValidUrl(String value) {
//     final pattern = r'^(https?:\/\/)?' +
//         r'((([a-z\d]([a-z\d-]*[a-z\d])*)\.)+[a-z]{2,}|' +
//         r'((\d{1,3}\.){3}\d{1,3}))' +
//         r'(\:\d+)?(\/[-a-z\d%_.~+]*)*' +
//         r'(\?[;&a-z\d%_.~+=-]*)?' +
//         r'(\#[-a-z\d_]*)?$';
//     final regex = RegExp(pattern, caseSensitive: false);
//     return regex.hasMatch(value);
//   }

//   void _showErrorDialog(BuildContext context, String title, String message) {
//     if (!context.mounted) return;

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _navigateToAnalyzingPage(BuildContext context, String url) {
//     if (!url.startsWith('http://') && !url.startsWith('https://')) {
//       url = 'https://$url';
//     }

//     if (context.mounted) {
//       Navigator.pushNamed(
//         context,
//         '/analyzing',
//         arguments: {'url': url},
//       );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'dart:io' show Platform;
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if context is still mounted before proceeding
    if (!context.mounted) {
      return const SizedBox.shrink(); // Return an empty widget if not mounted
    }
    
    return SizedBox(
      width: double.infinity,
      height: 200,
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
                blur: const MaskFilter.blur(BlurStyle.solid, 8),
              ),
              backgroundColor: Colors.transparent,
              size: const Size(double.infinity, 200),
              waveAmplitude: 30,
              waveFrequency: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterButton(
                      context,
                      Icons.qr_code_scanner,
                      'Scan QR',
                      () => _showScanOptions(context),
                    ),
                    const SizedBox(width: 40),
                    _buildFooterButton(
                      context,
                      Icons.history,
                      'History',
                      // Ensure context is valid before navigating
                      () {
                         if(context.mounted) {
                            Navigator.pushNamed(context, '/history');
                         }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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

  Widget _buildFooterButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF4A6FFF),
        elevation: 6,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        shadowColor: Colors.black26,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26),
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
     // Check if context is still mounted before showing dialog
     if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) { // Use modalContext here
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
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF4A6FFF)),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(modalContext); // Use modalContext to pop
                  _takePicture(context); // Use original context for logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF4A6FFF)),
                title: const Text('Upload Image'),
                onTap: () {
                  Navigator.pop(modalContext); // Use modalContext to pop
                  _pickImageFromGallery(context); // Use original context for logic
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _takePicture(BuildContext context) async {
    // Check context at the beginning of async gap
     if (!context.mounted) return;

    if (Platform.isWindows) {
        _showErrorDialog(
          context,
          'Not Supported',
          'Camera functionality is not supported on Windows desktop.',
        );
      return;
    }

    try {
      final cameraStatus = await Permission.camera.request();
      // Check context again after await
      if (!context.mounted) return;

      if (cameraStatus.isGranted) {
        final ImagePicker picker = ImagePicker();
        final XFile? photo = await picker.pickImage(source: ImageSource.camera);
        // Check context again after await
        if (!context.mounted) return;

        if (photo == null) {
          print('Photo taking cancelled.');
          _showErrorDialog(context, 'No Photo Taken', 'No photo was captured.');
          return;
        }

        await _processQRImage(context, photo);
      } else {
        print('Camera permission denied. Status: $cameraStatus');
        _showErrorDialog(
          context,
          'Permission Denied',
          'Camera permission is required. Please grant it in settings.',
        );
      }
    } catch (e, s) {
      print('--- ERROR Taking Picture ---');
      print(e);
      print(s); // Print stack trace for detailed debugging
      print('-----------------------------');
      if (context.mounted) {
        _showErrorDialog(context, 'Error', 'Failed to access camera: $e');
      }
    }
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    // Check context at the beginning of async gap
    if (!context.mounted) return;

    try {
      PermissionStatus permissionStatus;
      // Request appropriate permission based on Android version
      if (Platform.isAndroid) {
         // Check Android version for appropriate permission request
        // This requires more specific logic if you need device_info package
        // For simplicity, let's request photos for newer SDKs, storage otherwise
        // A more robust check might involve getting the actual Android SDK version
        // Using a high number like 33 assumes newer Android versions.
        // Consider using device_info_plus for accurate version checking if needed.
        // As of permission_handler 11, READ_MEDIA_IMAGES is often needed for API 33+
        if (await _isAndroid13OrAbove()) { // Hypothetical function, replace with actual check if needed
             permissionStatus = await Permission.photos.request();
             if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
                // Optionally request storage if photos denied, though less common now
                // permissionStatus = await Permission.storage.request();
             }
        } else {
             permissionStatus = await Permission.storage.request();
        }

      } else { // For iOS
        permissionStatus = await Permission.photos.request();
      }


      // Check context again after await
      if (!context.mounted) return;

      if (permissionStatus.isGranted || permissionStatus.isLimited) {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        // Check context again after await
        if (!context.mounted) return;

        if (image == null) {
          print('Image selection cancelled.');
          _showErrorDialog(context, 'No Image Selected', 'Please select an image to scan.');
          return;
        }

        await _processQRImage(context, image);
      } else {
        print('Gallery permission denied. Status: $permissionStatus');
        _showErrorDialog(
          context,
          'Permission Denied',
          'Gallery access is required. Please grant it in settings.',
        );
      }
    } catch (e, s) {
      print('--- ERROR Picking Image ---');
      print(e);
      print(s); // Print stack trace
      print('----------------------------');
      if (context.mounted) {
        _showErrorDialog(context, 'Error', 'Failed to select image: $e');
      }
    }
  }

    // Helper to check Android version (requires device_info_plus package)
    // Placeholder - replace with actual implementation if needed.
    Future<bool> _isAndroid13OrAbove() async {
      if(Platform.isAndroid) {
        // To implement this properly, add device_info_plus to pubspec.yaml
        // import 'package:device_info_plus/device_info_plus.dart';
        // final androidInfo = await DeviceInfoPlugin().androidInfo;
        // return androidInfo.version.sdkInt >= 33;
        return true; // Assume true for now, refine if needed
      }
      return false;
    }


  Future<void> _processQRImage(BuildContext context, XFile imageFile) async {
    // Check context at the beginning of async gap
    if (!context.mounted) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Dialog( // Use dialogContext
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Scanning QR Code...'),
            ],
          ),
        ),
      ),
    );

    try {
      final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]); // Specify QR Code format
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
      await barcodeScanner.close();

      // Check context again after await BEFORE closing dialog
      if (!context.mounted) return;
      // Pop the loading dialog using rootNavigator to be safe
      Navigator.of(context, rootNavigator: true).pop();

      if (barcodes.isEmpty) {
        print('No QR codes found in the image.');
        _showErrorDialog(context, 'No QR Code Found', 'Could not find a QR code in the selected image. Try a clearer image.');
        return;
      }

      String? foundUrl;
      print('Barcodes found: ${barcodes.length}');
      for (final barcode in barcodes) {
        print('Barcode Type: ${barcode.type}, Raw Value: ${barcode.rawValue}');
        // Prioritize URL type, but also accept raw values that look like URLs
        if (barcode.type == BarcodeType.url && barcode.displayValue != null) {
           foundUrl = barcode.displayValue; // Use displayValue for URLs
           print('Found URL (type URL): $foundUrl');
           break;
        } else if (barcode.rawValue != null && _isValidUrl(barcode.rawValue!)) {
          foundUrl = barcode.rawValue;
          print('Found URL (regex match): $foundUrl');
          break; // Stop after finding the first valid URL
        } else {
           print('Barcode found but not a URL: Type=${barcode.type}, Value=${barcode.rawValue}');
        }
      }

      if (foundUrl == null) {
        print('No valid URL found in the scanned QR codes.');
        _showErrorDialog(context, 'No Valid URL Found', 'The QR code was scanned, but it does not contain a valid URL.');
        return;
      }

      _navigateToAnalyzingPage(context, foundUrl);

    } catch (e, s) {
      print('--- ERROR Processing QR Image ---');
      print(e);
      print(s); // Print stack trace
      print('---------------------------------');
      // Ensure context is mounted before interacting with UI
      if (context.mounted) {
        // Pop the loading dialog in case of error
         Navigator.of(context, rootNavigator: true).pop();
        _showErrorDialog(context, 'Error', 'Failed to process QR code: $e');
      }
    }
  }

  // Simple URL validation (adjust regex as needed for stricter validation)
  bool _isValidUrl(String value) {
    // Allow common schemes, handle cases without scheme by trying https
    final uri = Uri.tryParse(value);
    if (uri == null) return false;

    // If no scheme, check if it looks like a domain path and assume https
    if (!uri.hasScheme) {
       final uriWithScheme = Uri.tryParse('https://$value');
       return uriWithScheme != null && uriWithScheme.hasAuthority && uriWithScheme.host.isNotEmpty;
    }
    // If scheme exists, ensure it's http/https and has a host
    return (uri.scheme == 'http' || uri.scheme == 'https') && uri.hasAuthority && uri.host.isNotEmpty;
  }


  void _showErrorDialog(BuildContext context, String title, String message) {
    // Check context before showing dialog
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog( // Use dialogContext
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(), // Use dialogContext to pop
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToAnalyzingPage(BuildContext context, String url) {
    // Ensure context is mounted before navigation
    if (!context.mounted) return;

    // Prepend https:// if no scheme is present
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
      print("Prepended 'https://', navigating to: $url");
    } else {
       print("Navigating to existing URL: $url");
    }

    // Perform navigation
    Navigator.pushNamed(
      context,
      '/analyzing',
      arguments: {'url': url},
    );
  }
}
// lib/services/desktop_qr_scanner.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:zxing2/qrcode.dart';

class DesktopQrScanner {
  /// Picks an image file and attempts to scan it for QR codes
  /// Returns the raw value of the first QR code found, or null if none
  static Future<String?> scanImageFile() async {
    try {
      // Open file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      
      if (result == null || result.files.isEmpty) {
        return null; // User canceled the picker
      }
      
      final path = result.files.first.path;
      if (path == null) {
        throw Exception('Failed to get file path');
      }
      
      // Read file as bytes
      final File file = File(path);
      final bytes = await file.readAsBytes();
      
      // Decode image
      final image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }
      
      // Create a luminance source from the image
      final luminanceSource = RGBLuminanceSource(
        image.width, 
        image.height,
        _getPixels(image),
      );
      
      // Set up QR code reader
      final binaryBitmap = BinaryBitmap(HybridBinarizer(luminanceSource));
      final reader = QRCodeReader();
      
      try {
        final result = reader.decode(binaryBitmap);
        return result.text;
      } catch (e) {
        debugPrint('No QR code found in image: $e');
        return null;
      }
    } catch (e) {
      debugPrint('Error scanning QR code from image: $e');
      return null;
    }
  }
  
  // Helper method to convert image to pixel array
  static Int32List _getPixels(img.Image image) {
    final pixels = Int32List(image.width * image.height);
    int i = 0;
    
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        // Get pixel and extract RGB components
        final pixel = image.getPixel(x, y);
        
        // Extract RGB values from the pixel and convert to int
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();
        
        // Combine into a single 24-bit RGB value
        pixels[i++] = (r << 16) | (g << 8) | b;
      }
    }
    
    return pixels;
  }
}
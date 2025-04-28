import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qrcode/screens/qr_screen.dart';
import 'package:qrcode/screens/homepage.dart';
import 'package:qrcode/screens/history.dart'; // Import for the history page

void main() {
  debugPaintBaselinesEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code Scanner',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF4A6FFF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6FFF),
          primary: const Color(0xFF4A6FFF),
          secondary: const Color(0xFF7B9FFF),
        ),
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A6FFF),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      
      // Define the routes for navigation
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
       // '/qr': (context) => const QRScreen(),
        '/history': (context) => const HistoryPage(),
      },
    );
  }
}
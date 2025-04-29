import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode/screens/homepage.dart';
import 'package:qrcode/screens/history.dart';
import 'package:qrcode/screens/analyzing_page.dart'; // Add import for new analyzing page
import 'package:qrcode/screens/results_page.dart';

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner',
      debugShowCheckedModeBanner: false,
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4A6FFF),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/history': (context) => const HistoryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/analyzing') {
          final arguments = settings.arguments as Map<String, dynamic>?;
          final url = arguments?['url'] as String?;
          
          // Use the new AnalyzingPage
          return MaterialPageRoute(
            builder: (context) => AnalyzingPage(url: url ?? ''),
          );
        }

        if (settings.name == '/results') {
          final arguments = settings.arguments as Map<String, dynamic>?;
          final url = arguments?['url'] as String?;
          return MaterialPageRoute(
            builder: (context) => ResultsPage(url: url),
          );
        }

        // Unknown route fallback
        return MaterialPageRoute(builder: (context) => const MainPage());
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:qrcode/screens/qr_screen.dart';
import 'package:qrcode/screens/homepage.dart';
import 'package:qrcode/screens/history.dart';
import 'package:qrcode/url_check_page.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/cubit/qr_cubit.dart';
import 'package:qrcode/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrCubit(ApiService(baseUrl: 'http://127.0.0.1:5000')),
      child: MaterialApp(
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
        initialRoute: '/',
        routes: {
          '/': (context) => const MainPage(),
          '/history': (context) => const HistoryPage(),
          '/url-check': (context) => const UrlCheckPage(),
        },
      ),
    );
  }
}

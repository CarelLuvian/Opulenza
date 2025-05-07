import 'package:flutter/material.dart';
import 'splash_screen1.dart'; // Import halaman tujuan

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigasi otomatis setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1A1A), // Warna latar belakang
      body: Center(
        child: Image.asset(
          'Assets/Background/Opulenza.png', // Ganti sesuai path/logo kamu
          width: 400,
        ),
      ),
    );
  }
}

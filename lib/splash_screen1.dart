import 'package:flutter/material.dart';
import 'splash_screen2.dart';

class SplashScreen1 extends StatelessWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
      child: Transform.translate(
          offset: Offset(0, -120), // naik 30 pixel
            child: Image.asset(
              'Assets/Background/background_splash_screen1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          ),

          // Card di bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 60), // Tambahkan padding bawah, bukan margin
              decoration: const BoxDecoration(
                color: Color(0xFFEBECE5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIndicator(isActive: true),
                      const SizedBox(width: 8),
                      _buildIndicator(isActive: false),
                      const SizedBox(width: 8),
                      _buildIndicator(isActive: false),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Text
                  const Text(
                    'Aset mewah kini dalam genggaman, Jelajahi, Miliki, Tampil lebih istimewa.',
                    style: TextStyle(
                      color: Color(0xFF5C4F43),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SplashScreen2()),
                        );
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return Container(
      width: isActive ? 20 : 10,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.black45 : Colors.grey[400],
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

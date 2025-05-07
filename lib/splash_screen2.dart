import 'package:flutter/material.dart';
import 'package:opulenza/get_started.dart';

class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image dengan posisi dinaikkan
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0, -120),
              child: Image.asset(
                'Assets/Background/background_splash_screen2.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Card di bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 60),
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
                      _buildIndicator(isActive: false),
                      const SizedBox(width: 8),
                      _buildIndicator(isActive: true),
                      const SizedBox(width: 8),
                      _buildIndicator(isActive: false),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Text
                  const Text(
                    "Barang impianmu, \nDisorot, Dipromosikan,\nSiap kamu miliki",
                    style: TextStyle(
                      color: Color(0xFF5C4F43),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                            MaterialPageRoute(builder: (_) => const GetStartedPage()),
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

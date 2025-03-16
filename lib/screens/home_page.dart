import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the web background image for both web and mobile
    const String backgroundImage = 'assets/images/homebgweb.jpeg';

    // Adjust text color based on background
    const Color textColor = Colors.black87; // Suited for white background
    const Color shadowColor = Colors.white70;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Bridge for Rural Empowerment'),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to\nDigital Bridge for Rural Empowerment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor, // Adjusted for white background
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: shadowColor,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/welcome'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text('Get Started', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User Type'),
      ),
      body: Stack(
        children: [
          // Background Image with Adaptive Fit
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Image.asset(
                  'assets/images/ut.webp', // Ensure image exists in assets
                  fit: constraints.maxWidth > 600 ? BoxFit.cover : BoxFit.fill,
                );
              },
            ),
          ),

          // Dark Overlay for Better Readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Adjust opacity as needed
            ),
          ),

          // Main Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildUserTypeCard(
                  context,
                  'User',
                  Icons.person,
                  Colors.blue,
                  '/user-login',
                ),
                const SizedBox(height: 20),
                _buildUserTypeCard(
                  context,
                  'Admin',
                  Icons.admin_panel_settings,
                  Colors.green,
                  '/admin-login',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeCard(
      BuildContext context, String title, IconData icon, Color color, String route) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.9), // Better visibility
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(icon, size: 40, color: color),
        title: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}

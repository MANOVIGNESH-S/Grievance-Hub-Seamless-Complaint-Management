import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User Type'),
      ),
      body: Padding(
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
    );
  }

  Widget _buildUserTypeCard(
      BuildContext context, String title, IconData icon, Color color, String route) {
    return Card(
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(icon, size: 40, color: color),
        title: Text(title, style: const TextStyle(fontSize: 20)),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
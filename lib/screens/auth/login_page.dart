import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_flutter_app/services/auth_service.dart';
import 'package:my_flutter_app/models/user_model.dart';

class LoginPage extends StatefulWidget {
  final String userType;
  
  const LoginPage({super.key, required this.userType});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.userType} Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = await AuthService().loginUser(
                    _emailController.text,
                    _passwordController.text,
                    widget.userType, // Pass 'Admin' or 'User' here
                  );

                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid credentials. Please try again.')),
                    );
                    return;
                  }

                  // Save user session
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString(AuthService.currentUserKey, user.toJson());

                  // Navigate to the correct dashboard
                  if (user.type == 'Admin') {
                    Navigator.pushReplacementNamed(context, '/admin-dashboard');
                  } else {
                    Navigator.pushReplacementNamed(
                      context,
                      '/user-dashboard',
                      arguments: user, // Pass user data
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login failed: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                widget.userType == 'User' ? '/user-register' : '/admin-register',
              ),
              child: Text('Create ${widget.userType} Account'),
            ),
          ],
        ),
      ),
    );
  }
}

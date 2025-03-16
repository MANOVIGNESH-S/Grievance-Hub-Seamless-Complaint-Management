import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_flutter_app/screens/home_page.dart';
import 'package:my_flutter_app/screens/welcome_page.dart';
import 'package:my_flutter_app/screens/auth/login_page.dart';
import 'package:my_flutter_app/screens/auth/registration_page.dart';
import 'package:my_flutter_app/screens/dashboard/user_dashboard.dart';
import 'package:my_flutter_app/screens/dashboard/admin_dashboard.dart';
import 'package:my_flutter_app/models/user_model.dart';
import 'package:my_flutter_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final currentUserJson = prefs.getString(AuthService.currentUserKey);
  runApp(MyApp(currentUserJson: currentUserJson));
}

class MyApp extends StatelessWidget {
  final String? currentUserJson;

  const MyApp({super.key, this.currentUserJson});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grievance Center',
      // Always start with the root route
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(currentUserJson: currentUserJson),
        '/welcome': (context) => const WelcomeScreen(),
        '/user-login': (context) => LoginPage(userType: 'User'),
        '/admin-login': (context) => LoginPage(userType: 'Admin'),
        '/user-register': (context) => RegistrationPage(userType: 'User'),
        '/admin-register': (context) => RegistrationPage(userType: 'Admin'),
        '/user-dashboard': (context) => UserDashboard(
              user: ModalRoute.of(context)!.settings.arguments as User,
            ),
        '/admin-dashboard': (context) => const AdminDashboard(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final String? currentUserJson;
  
  const AuthWrapper({super.key, this.currentUserJson});
  
  @override
  Widget build(BuildContext context) {
    if (currentUserJson == null) {
      return const HomePage();
    }
    
    try {
      final user = User.fromJson(currentUserJson!);
      // Navigate to the correct dashboard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context,
          user.type == 'Admin' ? '/admin-dashboard' : '/user-dashboard',
          arguments: user,
        );
      });
    } catch (e) {
      // Handle invalid user data
      return const HomePage();
    }
    
    // Temporary loading screen
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
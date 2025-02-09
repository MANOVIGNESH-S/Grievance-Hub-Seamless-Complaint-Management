import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const usersKey = 'users';
  static const currentUserKey = 'currentUser'; // Changed to public constant

  Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await getUsers();

    if (users.any((u) => u.email == user.email)) {
      throw Exception('Email already registered');
    }

    users.add(user);
    await prefs.setStringList(usersKey, users.map((u) => u.toJson()).toList());
  }

  Future<User?> loginUser(String email, String password, String type) async {
    final users = await getUsers();
    try {
      final user = users.firstWhere(
        (u) => u.email == email && u.password == password && u.type == type,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(currentUserKey, user.toJson());
      return user;
    } catch (e) {
      throw Exception('Invalid credentials');
    }
  }

  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final userStrings = prefs.getStringList(usersKey) ?? [];
    return userStrings.map((str) => User.fromJson(str)).toList();
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(currentUserKey);
    return userJson != null ? User.fromJson(userJson) : null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(currentUserKey);
  }
}

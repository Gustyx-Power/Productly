import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  static const String userBoxName = 'users';
  static const String sessionBoxName = 'session';

  /// Mendaftarkan user baru
  static Future<bool> registerUser(UserModel user) async {
    final box = Hive.box<UserModel>(userBoxName);

    if (box.containsKey(user.email)) {
      return false; // Email sudah terdaftar
    }

    await box.put(user.email, user);
    return true;
  }

  /// Login user jika email dan password cocok
  static Future<bool> login(String email, String password) async {
    final userBox = Hive.box<UserModel>(userBoxName);
    final sessionBox = Hive.box(sessionBoxName);

    if (!userBox.containsKey(email)) return false;

    final user = userBox.get(email);
    if (user == null || user.password != password) return false;

    await sessionBox.put('isLoggedIn', true);
    await sessionBox.put('email', user.email);
    await sessionBox.put('name', user.name);

    return true;
  }

  /// Logout user
  static Future<void> logout() async {
    final sessionBox = Hive.box(sessionBoxName);
    await sessionBox.clear();
  }

  /// Cek apakah sudah login
  static Future<bool> isLoggedIn() async {
    final sessionBox = Hive.box(sessionBoxName);
    return sessionBox.get('isLoggedIn', defaultValue: false) as bool;
  }

  /// Ambil email dari session
  static String? getLoggedInEmail() {
    final sessionBox = Hive.box(sessionBoxName);
    return sessionBox.get('email');
  }

  /// Ambil nama user yang login
  static String? getLoggedInName() {
    final sessionBox = Hive.box(sessionBoxName);
    return sessionBox.get('name');
  }
}
import 'package:flutter/material.dart';
import 'package:lunaria/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  String? get userId => _user?.userId;

  UserProvider() {
    // Check for existing session on initialization
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    debugPrint('Checking current user session...');
    _status = AuthStatus.authenticating;
    notifyListeners();

    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        debugPrint('User session found: ${user.email}');
        _user = user;
        _status = AuthStatus.authenticated;
      } else {
        debugPrint('No active user session found');
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      debugPrint('Error checking user session: $e');
      _status = AuthStatus.error;
      _errorMessage = 'Gagal memeriksa sesi user: ${e.toString()}';
    }

    notifyListeners();
  }

  // Updated logIn method to handle the new exception from AuthService
  Future<bool> logIn({required String email, required String password}) async {
    debugPrint('Attempting to log in user: $email');
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.logIn(email: email, password: password);

      if (user != null) {
        debugPrint('Log in successful for: ${user.email}');
        debugPrint('User ID: ${user.userId}');
        _user = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        debugPrint('Sign in failed: user is null');
        _status = AuthStatus.error;
        _errorMessage = 'Email atau password salah';
        notifyListeners();
        return false;
      }
    } catch (e) {
      // This will now catch our custom exception when user exists in auth but not in users table
      debugPrint('Error during log in: $e');
      _status = AuthStatus.error;

      // Display the message from our custom exception
      if (e.toString().contains('Akun tidak ditemukan')) {
        _errorMessage = 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
      } else {
        _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      }

      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error signing out: $e');
    }
    notifyListeners();
  }

  void updateUserData(UserModel updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}

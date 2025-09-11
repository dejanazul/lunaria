import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
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

  // Updated signIn method to handle the new exception from AuthService
  Future<bool> signIn({required String email, required String password}) async {
    debugPrint('Attempting to sign in user: $email');
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signIn(email: email, password: password);

      if (user != null) {
        debugPrint('Sign in successful for: ${user.email}');
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
    } on AuthException catch (e) {
      debugPrint('Auth exception during sign in: ${e.message}');
      _status = AuthStatus.error;

      // Give more user-friendly error messages
      if (e.message.contains('Invalid login')) {
        _errorMessage = 'Email atau password salah';
      } else if (e.message.contains('Email not confirmed')) {
        _errorMessage = 'Silakan konfirmasi email Anda terlebih dahulu';
      } else {
        _errorMessage = 'Gagal login: ${e.message}';
      }

      notifyListeners();
      return false;
    } catch (e) {
      // This will now catch our custom exception when user exists in auth but not in users table
      debugPrint('Error during sign in: $e');
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

  // New method for completing the signup with all data
  Future<bool> completeSignUp({
    required String username,
    required String email,
    required String password,
    String? name,
    DateTime? birthDate,
    double? height,
    double? weight,
    DateTime? lastCycle,
    int? cycleDuration,
    String? fitnessLevel,
    String? lifestyle,
    List<String>? preferredActivities,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.completeSignUp(
        username: username,
        email: email,
        password: password,
        name: name,
        birthDate: birthDate,
        height: height,
        weight: weight,
        lastCycle: lastCycle,
        cycleDuration: cycleDuration,
        // fitnessLevel: fitnessLevel,
        lifestyle: lifestyle,
        preferredActivities: preferredActivities,
      );

      if (user != null) {
        _user = user;
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = 'Failed to complete signup';
        notifyListeners();
        return false;
      }
    } on AuthException catch (e) {
      _status = AuthStatus.error;

      // Give more user-friendly error messages
      if (e.message.contains('Email already registered')) {
        _errorMessage = 'Email sudah terdaftar. Silakan login.';
      } else {
        _errorMessage = 'Gagal mendaftar: ${e.message}';
      }

      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}

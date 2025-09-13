import 'package:flutter/material.dart';
import 'package:lunaria/models/menstrual_cycle_model.dart';
import 'package:lunaria/models/user_model.dart';
import 'package:lunaria/models/user_signup_model.dart';
import 'package:lunaria/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

class SignupDataProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? username;
  String? email;
  String? passwordHash;
  String? name;
  DateTime? birthDate;
  List<String>? preferredActivities;
  String? lifestyle;
  double? bmi;
  double? height;
  double? weight;
  DateTime? startDate;
  int? periodLength;

  UserModel? _user;
  MenstrualCycleModel? _cycle;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  MenstrualCycleModel? get cycle => _cycle;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;

  void _logDebugData(String updatedField, dynamic value) {
    debugPrint('=== SIGNUP DATA UPDATE ===');
    debugPrint('Updated field: $updatedField');
    debugPrint('New value: $value');
    debugPrint('--- Current Data ---');
    debugPrint('username: $username');
    debugPrint('email: $email');
    debugPrint('password: ${passwordHash != null ? '****' : 'null'}');
    debugPrint('name: $name');
    debugPrint('birthDate: ${birthDate?.toString() ?? 'null'}');
    debugPrint('height: $height');
    debugPrint('weight: $weight');
    debugPrint('lastCycle: ${startDate?.toString() ?? 'null'}');
    debugPrint('cycleDuration: $periodLength');
    debugPrint('preferredActivities: $preferredActivities');
    debugPrint('lifestyle: $lifestyle');
    debugPrint('bmi: $bmi');
    debugPrint('========================');
  }

  Future<Map<String, bool>> checkUsernameEmailAvailability({
    required String username,
    required String email,
  }) async {
    try {
      final result = await _authService.checkUsernameAndEmail(
        username: username,
        email: email,
      );

      // Simpan pesan error jika ada
      if (result['usernameExists'] == true) {
        _errorMessage =
            'Username sudah digunakan. Silakan pilih username lain.';
      } else if (result['emailExists'] == true) {
        _errorMessage =
            'Email sudah terdaftar. Silakan gunakan email lain atau login.';
      } else {
        _errorMessage = null;
      }

      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage =
          'Gagal memeriksa ketersediaan username dan email: ${e.toString()}';
      notifyListeners();
      return {'usernameExists': false, 'emailExists': false, 'error': true};
    }
  }

  // Method to update basic signup info (from signup page)
  Future<bool> updateSignupInfo({
    required String username,
    required String email,
    required String passwordHash,
  }) async {
    // Periksa ketersediaan username dan email terlebih dahulu
    final availabilityCheck = await checkUsernameEmailAvailability(
      username: username,
      email: email,
    );

    // Jika username atau email sudah digunakan, return false
    if (availabilityCheck['usernameExists'] == true ||
        availabilityCheck['emailExists'] == true ||
        availabilityCheck['error'] == true) {
      return false;
    }

    // Jika username dan email tersedia, simpan data
    this.username = username;
    this.email = email;
    this.passwordHash = passwordHash;
    notifyListeners();

    _logDebugData('signup info', {
      'username': username,
      'email': email,
      'passwordHash': '****',
    });

    return true;
  }

  // Method to update name
  void updateName(String name) {
    this.name = name;
    notifyListeners();
    _logDebugData('name', name);
  }

  // Method to update birthdate
  void updateBirthDate(DateTime birthDate) {
    this.birthDate = birthDate;
    notifyListeners();
    _logDebugData('birthDate', birthDate.toString());
  }

  // Method to update height
  void updateHeight(double height) {
    this.height = height;
    notifyListeners();
    _logDebugData('height', height);
  }

  // Method to update weight
  void updateWeight(double weight) {
    this.weight = weight;
    notifyListeners();
    _logDebugData('weight', weight);
  }

  // Method to update last cycle
  void updateLastCycle(DateTime startDate) {
    this.startDate = startDate;
    notifyListeners();
    _logDebugData('lastCycle', startDate.toString());
  }

  // Method to update cycle duration
  void updateCycleDuration(int periodLength) {
    this.periodLength = periodLength;
    notifyListeners();
    _logDebugData('cycleDuration', periodLength);
  }

  // Method to update preferred activities
  void updatePreferredActivities(List<String> activities) {
    preferredActivities = activities;
    notifyListeners();
    _logDebugData('preferredActivities', activities);
  }

  // Method to update lifestyle
  void updateLifestyle(String lifestyle) {
    this.lifestyle = lifestyle;
    notifyListeners();
    _logDebugData('lifestyle', lifestyle);
  }

  void updateBmi(double bmi) {
    this.bmi = bmi;
    notifyListeners();
    _logDebugData('bmi', bmi);
  }

  Future<bool> completeSignUp({
    required String username,
    required String email,
    required String passwordHash,
    String? name,
    DateTime? birthDate,
    List<String>? preferredActivities,
    String? lifestyle,
    double? bmi,
    double? height,
    double? weight,
    DateTime? lastCycle,
    int? cycleDuration,
  }) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.addUserData(
        userData: UserSignupModel(
          username: username,
          email: email,
          passwordHash: passwordHash,
          name: name,
          birthDate: birthDate,
          lifestyle: lifestyle,
          preferredActivities: preferredActivities,
          bmi: bmi,
          height: height,
          weight: weight,
        ),
        startDate: lastCycle ?? DateTime.now(),
        periodLength: cycleDuration,
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

  void debugPrintData() {}
}

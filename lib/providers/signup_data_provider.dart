import 'package:flutter/material.dart';
import 'package:lunaria/models/user_model.dart';
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
  String? password;
  String? name;
  DateTime? birthDate;
  double? height;
  double? weight;
  DateTime? startDate;
  int? periodLength;
  String? fitnessLevel;
  List<String>? preferredActivities;
  String? lifestyle;
  double? bmi;

  UserModel? _user;
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;

  // Helper method to log data after updates
  void _logDebugData(String updatedField, dynamic value) {
    debugPrint('=== SIGNUP DATA UPDATE ===');
    debugPrint('Updated field: $updatedField');
    debugPrint('New value: $value');
    debugPrint('--- Current Data ---');
    debugPrint('username: $username');
    debugPrint('email: $email');
    debugPrint('password: ${password != null ? '****' : 'null'}');
    debugPrint('name: $name');
    debugPrint('birthDate: ${birthDate?.toString() ?? 'null'}');
    debugPrint('height: $height');
    debugPrint('weight: $weight');
    debugPrint('lastCycle: ${startDate?.toString() ?? 'null'}');
    debugPrint('cycleDuration: $periodLength');
    debugPrint('fitnessLevel: $fitnessLevel');
    debugPrint('preferredActivities: $preferredActivities');
    debugPrint('lifestyle: $lifestyle');
    debugPrint('bmi: $bmi');
    debugPrint('========================');
  }

  // Method to update basic signup info (from signup page)
  void updateSignupInfo({
    required String username,
    required String email,
    required String password,
  }) {
    this.username = username;
    this.email = email;
    this.password = password;
    notifyListeners();
    _logDebugData('signup info', {'username': username, 'email': email});
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

  // Method to update fitness level
  void updateFitnessLevel(String fitnessLevel) {
    this.fitnessLevel = fitnessLevel;
    notifyListeners();
    _logDebugData('fitnessLevel', fitnessLevel);
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

  // Check if we have collected the minimum required information
  bool get hasRequiredInfo {
    return username != null &&
        email != null &&
        password != null &&
        name != null;
  }

  // Reset all data
  void reset() {
    username = null;
    email = null;
    password = null;
    name = null;
    birthDate = null;
    height = null;
    weight = null;
    startDate = null;
    periodLength = null;
    fitnessLevel = null;
    preferredActivities = null;
    lifestyle = null;
    bmi = null;
    notifyListeners();
    debugPrint('=== SIGNUP DATA RESET ===');
  }

  Future<bool> completeSignUp({
    required String username,
    required String email,
    required String password,
    String? name,
    DateTime? birthDate,
    DateTime? lastCycle,
    int? cycleDuration,
    String? fitnessLevel,
    String? lifestyle,
    List<String>? preferredActivities,
    double? bmi,
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
        startDate: lastCycle,
        periodLength: cycleDuration,
        lifestyle: lifestyle,
        preferredActivities: preferredActivities,
        bmi: bmi,
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

import 'package:flutter/material.dart';

class SignupDataProvider extends ChangeNotifier {
  String? username;
  String? email;
  String? password;
  String? name;
  DateTime? birthDate;
  double? height;
  double? weight;
  DateTime? lastCycle;
  int? cycleDuration;
  String? fitnessLevel;
  List<String>? preferredActivities;
  String? lifestyle;
  double? bmi;

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
    debugPrint('lastCycle: ${lastCycle?.toString() ?? 'null'}');
    debugPrint('cycleDuration: $cycleDuration');
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
  void updateLastCycle(DateTime lastCycle) {
    this.lastCycle = lastCycle;
    notifyListeners();
    _logDebugData('lastCycle', lastCycle.toString());
  }

  // Method to update cycle duration
  void updateCycleDuration(int cycleDuration) {
    this.cycleDuration = cycleDuration;
    notifyListeners();
    _logDebugData('cycleDuration', cycleDuration);
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
    lastCycle = null;
    cycleDuration = null;
    fitnessLevel = null;
    preferredActivities = null;
    lifestyle = null;
    bmi = null;
    notifyListeners();
    debugPrint('=== SIGNUP DATA RESET ===');
  }

  void debugPrintData() {}
}

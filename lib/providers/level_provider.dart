import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/user_provider.dart';

class LevelProvider extends ChangeNotifier {
  int _level = 1;
  int _currentXP = 0;
  final int _baseXPNeeded = 100; // XP needed for level 2
  UserProvider? _userProvider;

  // Getters
  int get level => _level;
  int get currentXP => _currentXP;

  int get xpNeededForNextLevel {
    // Formula: Base XP * (current level ^ 1.5)
    // Level 1 needs 100 XP to reach level 2
    // Level 2 needs 283 XP to reach level 3
    // Level 3 needs 520 XP to reach level 4, etc.
    return (_baseXPNeeded * (Math.pow(_level, 1.5))).round();
  }

  // Inisialisasi dengan user provider
  void initialize(UserProvider userProvider) {
    _userProvider = userProvider;

    // Load level and XP from user data if available
    if (_userProvider?.user != null) {
      _level = _userProvider!.user!.level;
      _currentXP = _userProvider!.user!.exp;
    }

    notifyListeners();
  }

  // Add XP and handle level up
  Future<void> addXP(int xpPoints) async {
    _currentXP += xpPoints;

    // Check for level up
    while (_currentXP >= xpNeededForNextLevel) {
      _currentXP -= xpNeededForNextLevel;
      _level++;
    }

    notifyListeners();

    // Save to database if user is logged in
    if (_userProvider?.user != null) {
      await _saveToDatabase();
    }
  }

  // Save level data to database
  Future<void> _saveToDatabase() async {
    try {
      if (_userProvider?.user?.id == null) return;

      final supabase = Supabase.instance.client;
      await supabase
          .from('users')
          .update({'level': _level, 'exp': _currentXP})
          .eq('user_id', _userProvider!.user!.id as Object);

      // Update local user model
      if (_userProvider?.user != null) {
        final updatedUser = _userProvider!.user!.copyWith(
          level: _level,
          exp: _currentXP,
        );
        _userProvider!.updateUserData(updatedUser);
      }

      debugPrint(
        'Level data saved successfully: Level $_level, XP $_currentXP',
      );
    } catch (e) {
      debugPrint('Error saving level data: $e');
    }
  }

  // Method to sync level from database
  Future<void> syncFromDatabase() async {
    if (_userProvider?.user?.id == null) return;

    try {
      final supabase = Supabase.instance.client;
      final response =
          await supabase
              .from('users')
              .select('level, exp')
              .eq('user_id', _userProvider!.user!.id as Object)
              .single();

      _level = response['level'] ?? 1;
      _currentXP = response['exp'] ?? 0;
      notifyListeners();
        } catch (e) {
      debugPrint('Error syncing level data: $e');
    }
  }
}

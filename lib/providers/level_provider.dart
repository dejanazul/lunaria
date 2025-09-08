import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider untuk mengelola level dan XP karakter
class LevelProvider extends ChangeNotifier {
  int _level = 0;
  int _currentXP = 0;
  static const String _levelKey = 'level';
  static const String _xpKey = 'current_xp';

  LevelProvider() {
    _loadSavedData();
  }

  /// Level karakter saat ini
  int get level => _level;

  /// XP karakter saat ini
  int get currentXP => _currentXP;

  /// XP yang dibutuhkan untuk naik level berikutnya
  /// Formula: 100 * (level + 1)
  int get xpNeededForNextLevel => 100 * (_level + 1);

  /// Persentase progres XP (0.0 - 1.0)
  double get progressPercentage => _currentXP / xpNeededForNextLevel;

  /// Menambahkan XP dan cek apakah level up
  void addXP(int amount) {
    if (amount <= 0) return;

    _currentXP += amount;
    _checkLevelUp();
    _saveData();
    notifyListeners();
  }

  /// Set level secara manual (untuk debug/testing)
  void setLevel(int level) {
    if (level < 0) return;

    _level = level;
    _currentXP = 0;
    _saveData();
    notifyListeners();
  }

  /// Reset level dan XP ke 0
  void resetProgress() {
    _level = 0;
    _currentXP = 0;
    _saveData();
    notifyListeners();
  }

  /// Cek apakah XP cukup untuk naik level
  void _checkLevelUp() {
    while (_currentXP >= xpNeededForNextLevel) {
      _currentXP -= xpNeededForNextLevel;
      _level++;
    }
  }

  /// Load data dari SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    _level = prefs.getInt(_levelKey) ?? 0;
    _currentXP = prefs.getInt(_xpKey) ?? 0;
    notifyListeners();
  }

  /// Simpan data ke SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_levelKey, _level);
    await prefs.setInt(_xpKey, _currentXP);
  }
}

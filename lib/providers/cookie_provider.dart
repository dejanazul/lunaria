import 'package:flutter/material.dart';

class CookieProvider extends ChangeNotifier {
  int _cookies = 100;

  int get cookies => _cookies;

  void addCookies(int amount) {
    _cookies += amount;
    notifyListeners();
  }

  bool spendCookies(int amount) {
    if (_cookies >= amount) {
      _cookies -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  void setCookies(int amount) {
    _cookies = amount;
    notifyListeners();
  }
}

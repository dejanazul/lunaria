import 'package:flutter/material.dart';
import 'package:lunaria/providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CookieProvider extends ChangeNotifier {
  UserProvider? _userProvider;
  int _cookies = 0;
  int get cookies => _cookies;

  void initialize(UserProvider userProvider) {
    _userProvider = userProvider;
    // Load initial cookies from user data if available
    if (_userProvider?.user != null) {
      _cookies = _userProvider!.user!.cookieBalance!;
    }
    notifyListeners();
  }

  Future<void> syncFromDatabase() async {
    if (_userProvider?.user?.userId == null) return;
    try {
      final supabase = Supabase.instance.client;
      final response =
          await supabase
              .from('users')
              .select('cookie_balance')
              .eq('user_id', _userProvider!.user!.userId as Object)
              .single();
      _cookies = response['cookie_balance'] ?? 0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error syncing cookies from database: $e');
    }
  }

  Future<void> _saveToDatabase() async {
    try {
      if (_userProvider?.user?.userId == null) return;

      final supabase = Supabase.instance.client;
      await supabase
          .from('users')
          .update({'cookie_balance': _cookies})
          .eq('user_id', _userProvider!.user!.userId as Object);

      // Update local user model
      if (_userProvider?.user != null) {
        final updatedUser = _userProvider!.user!.copyWith(
          cookieBalance: _cookies,
        );
        _userProvider!.updateUserData(updatedUser);
      }

      debugPrint('Cookie balance saved successfully: $_cookies');
    } catch (e) {
      debugPrint('Error saving cookie balance: $e');
    }
  }

  Future<void> addCookies(int amount) async {
    _cookies += amount;
    notifyListeners();

    if (_userProvider?.user != null) {
      await _saveToDatabase();
    }
  }
}

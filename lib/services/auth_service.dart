import 'package:flutter/material.dart';
import 'package:lunaria/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_signup_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  String? get currentUserId {
    final user = _supabase.auth.currentUser;
    return user?.id;
  }

  Future<String?> getUserIdByEmail(String email) async {
    try {
      final userData =
          await _supabase
              .from('users')
              .select('user_id')
              .eq('email', email)
              .single();

      return userData['user_id'] as String?;
    } catch (e) {
      debugPrint('Error getting user_id by email: $e');
      return null;
    }
  }

  Future<UserSignupModel?> addUserData({
    required UserSignupModel userData,
    required startDate,
    required periodLength,
  }) async {
    try {
      final response = await _supabase
          .from('users')
          .insert(userData.toJson())
          .select('user_id');

      final userId = response[0]['user_id'] as String;

      await _supabase.from("menstrual_cycles").insert({
        'user_id': userId,
        'start_date': startDate.toIso8601String(),
        'period_length': periodLength,
      });
      return userData;
    } on AuthException catch (e) {
      debugPrint('Auth error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during signup: $e');
      rethrow;
    }
  }

  Future<Map<String, bool>> checkUsernameAndEmail({
    required String username,
    required String email,
  }) async {
    try {
      final usernameExists =
          await _supabase
              .from('users')
              .select('username')
              .eq('username', username)
              .maybeSingle();

      // Cek apakah email sudah ada
      final emailExists =
          await _supabase
              .from('users')
              .select('email')
              .eq('email', email)
              .maybeSingle();

      return {
        'usernameExists': usernameExists != null,
        'emailExists': emailExists != null,
      };
    } catch (e) {
      debugPrint('Error checking username and email: $e');
      // Jika terjadi error, kembalikan false untuk keduanya agar pengguna bisa mencoba lagi
      return {'usernameExists': false, 'emailExists': false};
    }
  }

  Future<UserModel?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final userByEmail =
          await _supabase
              .from("users")
              .select('*')
              .eq("email", email)
              .maybeSingle();

      // 2. Jika email tidak ditemukan
      if (userByEmail == null) {
        debugPrint('Login gagal: email tidak ditemukan');
        throw Exception(
          'Email tidak terdaftar. Silakan daftar terlebih dahulu.',
        );
      }

      // 3. Jika email ditemukan, cek password
      if (userByEmail['password_hash'] != password) {
        debugPrint('Login gagal: password salah');
        throw Exception('Password yang Anda masukkan salah.');
      }

      debugPrint('Login berhasil untuk user: ${userByEmail['username']}');
      debugPrint('User ID: ${userByEmail['user_id']}');

      return UserModel.fromJson(userByEmail);
    } on PostgrestException catch (e) {
      debugPrint('Database error: ${e.message}');
      throw Exception('Gagal mengakses database: ${e.message}');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      // Error lainnya
      debugPrint('Error saat login: $e');
      throw Exception('Terjadi kesalahan. Silakan coba lagi.');
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final User? user = _supabase.auth.currentUser;

      if (user != null) {
        final userData =
            await _supabase
                .from('users')
                .select("*")
                .eq('user_id', user.id)
                .single();

        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }
}

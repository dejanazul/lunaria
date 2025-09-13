import 'package:flutter/material.dart';
import 'package:lunaria/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_signup_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

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
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        debugPrint('Login berhasil untuk user: ${response.user!.email}');

        try {
          // Ambil data user dari tabel users
          final userData =
              await _supabase
                  .from('users')
                  .select()
                  .eq('user_id', response.user!.id)
                  .single();

          debugPrint('Data user berhasil diambil');
          return UserModel.fromJson(userData);
        } catch (e) {
          // User exists in auth but not in users table
          await _supabase.auth.signOut(); // Sign out the user
          throw Exception(
            'Akun tidak ditemukan. Silakan daftar terlebih dahulu.',
          );
        }
      } else {
        debugPrint('Login gagal: user null');
        return null;
      }
    } on AuthException catch (e) {
      debugPrint('Auth error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Error saat login: $e');
      rethrow;
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
                .select()
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

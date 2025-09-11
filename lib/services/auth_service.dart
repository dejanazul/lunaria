import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Complete signup with all user data
  Future<UserModel?> completeSignUp({
    required String username,
    required String email,
    required String password,
    String? name,
    DateTime? birthDate,
    double? height,
    double? weight,
    DateTime? lastCycle,
    int? cycleDuration,
    // String? fitnessLevel,
    String? lifestyle,
    List<String>? preferredActivities,
  }) async {
    try {
      // 1. Create auth user
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Failed to create user');
      }

      final userId = response.user!.id;

      // Calculate BMI if height and weight are available
      double? calculatedBmi;
      if (height != null && weight != null) {
        final heightInMeters = height / 100; // Convert cm to m
        calculatedBmi = weight / (heightInMeters * heightInMeters);
        calculatedBmi = double.parse(
          calculatedBmi.toStringAsFixed(2),
        ); // Round to 2 decimal places
      }

      // 2. Create full user model with all profile data
      final userModel = UserModel(
        id: userId,
        username: username,
        email: email,
        passwordHash:
            password, // Use actual password - real hashing is handled by Supabase Auth
        name: name,
        birthDate: birthDate,
        preferredActivities: preferredActivities,
        // height: height,
        // weight: weight,
        lifestyle: lifestyle,
        bmi: calculatedBmi,
        // fitnessLevel: fitnessLevel,
      );

      // 3. Insert complete user data to the 'users' table
      await _supabase.from('users').insert(userModel.toJson());

      // 4. If menstrual cycle data is provided, save it to the menstrual_cycles table
      if (lastCycle != null) {
        // Create a new menstrual cycle entry
        final menstrualCycleData = {
          'user_id': userId,
          'start_date': lastCycle.toIso8601String(),
          'period_length': cycleDuration,
        };

        await _supabase.from('menstrual_cycles').insert(menstrualCycleData);
      }

      return userModel;
    } on AuthException catch (e) {
      debugPrint('Auth error: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error during signup: $e');
      rethrow;
    }
  }

  // Sign in user dengan email dan password
  Future<UserModel?> signIn({
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

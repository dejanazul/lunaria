import 'package:flutter/material.dart';
import 'package:lunaria/models/menstrual_cycle_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CalendarAIService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<MenstrualCycleModel?> getUserMenstrualCycle(String userId) async {
    try {
      final response =
          await _supabase
              .from("menstrual_cycles")
              .select("*")
              .eq('user_id', userId)
              .maybeSingle();
      if (response == null) return null;
      return MenstrualCycleModel.fromJson(response);
    } catch (e) {
      debugPrint('Error getting user_id by email: $e');
      return null;
    }
  }
}

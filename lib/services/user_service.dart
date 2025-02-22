import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

// Save user profile after registration with optional phone number
  Future<void> saveUserProfile(String firstName, String lastName, {String? phoneNumber}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("No logged in user found");

    final Map<String, dynamic> userData = {
      'id': user.id,
      'first_name': firstName,
      'last_name': lastName,
    };

    // If phone number is provided, add it to the user data
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      userData['phone_number'] = phoneNumber;
    }

    await _supabase.from('carpoolusers').insert(userData);
  }


  // Check if user profile exists
  Future<bool> hasUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final response = await _supabase
        .from('carpoolusers')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    return response != null;
  }


  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('carpoolusers')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return response;
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("No logged in user found");

    await _supabase
        .from('carpoolusers')
        .update(updates)
        .eq('id', user.id);
  }

  // Delete user profile
  Future<void> deleteUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("No logged in user found");

    await _supabase.from('carpoolusers').delete().eq('id', user.id);
  }

}

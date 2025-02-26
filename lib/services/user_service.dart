import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

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

  Future<bool> hasUserCar() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final response = await _supabase
        .from('cars')
        .select('id')
        .eq('owner', user.id)
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

  // Upload profile image
  Future<String?> uploadProfileImage(XFile pickedFile) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("No logged in user found");

    // Datei-Pfad überprüfen
    if (pickedFile.path.isEmpty) {
      print("Error: Kein Dateipfad gefunden");
      return null;
    }
    var uuid = Uuid();
    final String uuid4 = uuid.v4();
    final File file = File(pickedFile.path);
    final String fileName = '${user.id}/$uuid4';
    print(fileName);

    try {
      // Datei hochladen
      await _supabase.storage.from('avatars').upload(
        fileName,
        file,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      // URL abrufen
      final String publicUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);

      // URL in der Datenbank speichern
      await updateUserProfile({'avatar_url': publicUrl});

      return publicUrl;
    } catch (e) {
      print("Fehler beim Hochladen des Bildes: $e");
      return null;
    }
  }

  // Get user by id
  Future<PostgrestList> getUserById(String userId) async {
    final response = await _supabase
        .from('carpoolusers')
        .select()
        .eq('id', userId);
    return response;
  }

  Future<String?> getPhoneNumber(String userId) async {
    try {
      // Rufe das Benutzerprofil anhand der userId ab
      final response = await _supabase
          .from('carpoolusers')
          .select('phone_number')
          .eq('id', userId)
          .maybeSingle();

      // Wenn das Profil gefunden wurde und eine Telefonnummer vorhanden ist, gib sie zurück
      if (response != null && response['phone_number'] != null) {
        return response['phone_number'] as String;
      }

      // Falls keine Telefonnummer gefunden wurde, gib null zurück
      return null;
    } catch (e) {
      print("Fehler beim Abrufen der Telefonnummer: $e");
      return null;
    }
  }
  // Delete user profile
  Future<void> deleteUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("No logged in user found");

    await _supabase.from('carpoolusers').delete().eq('id', user.id);
  }

}

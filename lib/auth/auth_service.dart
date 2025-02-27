import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;


// Sign in with email and password
  Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
        email: email, password: password);
    return response;
  }

//Sign up with email and password
Future<AuthResponse> signUpWithEmailAndPassword(String email, String password) async {
    final response = await _supabase.auth.signUp(
        email: email, password: password);
    return response;
}

//Sign out
Future<void> signOut() async {
    await _supabase.auth.signOut();
}

//Get user email
String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
}

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final supabase = Supabase.instance.client;

    try {
      // Aktuelle User-E-Mail abrufen
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('Kein User eingeloggt');

      // 1. Altes Passwort durch erneute Anmeldung überprüfen
      final signInResponse = await supabase.auth.signInWithPassword(
        email: user.email!,
        password: oldPassword,
      );

      // 2. Falls erfolgreich, Passwort ändern
      if (signInResponse.user != null) {
        await supabase.auth.updateUser(
          UserAttributes(password: newPassword),
        );
        print('Passwort erfolgreich geändert');
      }
    } catch (e) {
      print('Fehler beim Ändern des Passworts: $e');
    }
  }

// Update account information
  Future<void> changeEmail(String newEmail) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    print("Aktuelle User-E-Mail: ${user.email}");
    print("Neue E-Mail: $newEmail");

    // 1. E-Mail ändern
    await _supabase.auth.updateUser(UserAttributes(email: newEmail));

    print("E-Mail erfolgreich geändert");
  }


  String? getCurrentUserPendingEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.newEmail;
  }


}

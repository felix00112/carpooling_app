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

}

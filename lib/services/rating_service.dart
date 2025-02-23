import 'package:supabase_flutter/supabase_flutter.dart';

class RatingService{
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createRating(double rating, String forUserId, String review) async {
    final fromUser = _supabase.auth.currentUser;
    if (fromUser == null) {
      throw new Exception("User not logged in");
    }

    await _supabase.from("ratings").insert({
      "rating": rating,
      "for_user_id": forUserId,
      "review": review,
      "from_user_id": fromUser.id
    });
  }

  Future<List<Map<String, dynamic>>> getRatings(String user) async {
    final response = await _supabase
        .from('ratings')
        .select()
        .eq('to_user', user)
        .order('created_at', ascending: false); // newest first

    if (response.isEmpty) {
      return []; // no ratings found
    }

    return List<Map<String, dynamic>>.from(response);
  }

  Future<int> getRatingCount(String user) async {
    final response = await _supabase
        .from('ratings')
        .select('count')
        .eq('to_user', user)
        .single(); // single() sorgt dafür, dass nur ein Ergebnis zurückkommt

    return response['count'] as int? ?? 0;
  }

  Future<void> deleteRating(String ratingId) async {
    await _supabase
        .from('ratings')
        .delete()
        .eq('id', ratingId);
  }
}
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingService{
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createBooking(int rideId) async{
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw new Exception("User not logged in");
    }

    // todo: seats in ride should be checked, if seats are available -> create booking -> update seats in ride

    await _supabase.from('bookings').insert({
      'ride_id': rideId,
      'passenger_id': user.id,
    });
  }

  Future<List<Map<String, dynamic>>> getBookingsForRide(int rideId) async{
    final response = await _supabase
        .from('bookings')
        .select()
        .eq('ride_id', rideId); // only bookings for given ride

    return response ?? [];
  }

}
import 'package:supabase_flutter/supabase_flutter.dart';

class RideService{
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createRide(String start, String stop, DateTime date, int seats, bool flintaOnly, bool petsAllowed, bool luggageAllowed, int maxStops, List<String> paymentMethod) async{
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw new Exception("User not logged in");
    }

    await _supabase.from('rides').insert({
      'driver_id': user.id,
      'start_location': start,
      'stop_location': stop,
      'date': date,
      'seats_available': seats,
      'flinta_only': flintaOnly,
      'pets_allowed': petsAllowed,
      'luggage_allowed': luggageAllowed,
      'max_stopovers': maxStops,
      'payment_method': paymentMethod
    });
  }

  Future<List<Map<String, dynamic>>> getRides(DateTime date, String start, String stop) async {
    final response = await _supabase
        .from('rides')
        .select('id, driver_id, start_location, end_location, date, driver:carpoolusers(first_name)') // Fahrer-Name direkt laden
        .gte('date', date.toIso8601String())
        .lt('date', date.add(Duration(days: 7)).toIso8601String())
        .eq('start_location', start)
        .eq('end_location', stop)
        .order('date', ascending: true);

    return response ?? [];
  }


  Future<List<Map<String, dynamic>>> getUserBookedRides() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw new Exception("User not logged in");
    }
    final response = await _supabase
        .from('bookings')
        .select('*, ride:rides(*)') // gets all bookings and corresponding rides
        .eq('passenger_id', user.id); // only bookings for given user

    return response ?? [];
  }

  Future<List<Map<String, dynamic>>> getUserOfferedRides() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw new Exception("User not logged in");
    }
    final response = await _supabase
        .from('rides')
        .select('*, bookings:bookings(*)') // Holt alle Fahrten + die dazugehörigen Buchungen
        .eq('driver_id', user.id); // Filtert nur Fahrten des angegebenen Fahrers

    return response ?? [];
  }

  Future<Map<String, dynamic>?> getRideDetails(int rideId) async {
    final response = await _supabase
        .from('rides')
        .select('*,driver:carpoolusers(*),bookings:bookings(*, passenger:carpoolusers(*))') // loads driver, bookings and passengers
        .eq('id', rideId)
        .single(); // exactly one ride
    return response;
  }



//   Todo: Delete and update ride

}
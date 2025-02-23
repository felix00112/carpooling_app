import 'package:intl/intl.dart';
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

  Future<List<Map<String, dynamic>>> getRides(String date, String start, String stop) async {
    print("GET RIDES");
    print(date);
    String date7Days = addDaysToDateString(date, 7);
    print(date7Days);

    final response = await _supabase
        .from('rides')
        .select('id, driver_id, start_location, end_location, date, seats_available, driver:carpoolusers(first_name)') // Fahrer-Name direkt laden
        .gte('date', date)
        .lt('date', date7Days)
        .eq('start_location', start)
        .eq('end_location', stop)
        .order('date', ascending: true);

    return response ?? [];
  }

  Future<List<Map<String, dynamic>>> getAllRides() async {
    final response = await _supabase
        .from('rides')
        .select();
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
        .select('*, bookings:bookings(*)') // Gets all rides + corresponding bookings
        .eq('driver_id', user.id); // only rides for given user

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

  String addDaysToDateString(String dateString, int days) {
    DateTime parsedDate = DateTime.parse(dateString);
    DateTime newDate = parsedDate.add(Duration(days: days));

    // format to SupaBase date format
    return DateFormat("yyyy-MM-dd HH:mm:ss+00").format(newDate);
  }

//   Todo: Delete and update ride

}
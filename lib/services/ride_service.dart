import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/booking_service.dart';

class RideService{
  final SupabaseClient _supabase = Supabase.instance.client;
  BookingService _bookingService = BookingService();

  Future<int> createRide(String start, String stop, String date, int seats, bool flintaOnly, bool petsAllowed, bool luggageAllowed, int maxStops, List<String> paymentMethod) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw new Exception("User not logged in");
    }

    // Füge die Fahrt ein und erhalte die eingefügte Zeile zurück
    final response = await _supabase.from('rides').insert({
      'driver_id': user.id,
      'start_location': start,
      'end_location': stop,
      'date': date, // Hier wird der String verwendet
      'seats_available': seats,
      'flinta_only': flintaOnly,
      'pets_allowed': petsAllowed,
      'luggage_allowed': luggageAllowed,
      'max_stopovers': maxStops,
      'payment_method': paymentMethod
    }).select(); // Wähle die eingefügte Zeile aus

    // Extrahiere die ride_id aus der Antwort
    if (response != null && response.isNotEmpty) {
      return response[0]['id'] as int; // Rückgabe der ride_id
    } else {
      throw new Exception("Fehler beim Erstellen der Fahrt: Keine ID zurückgegeben");
    }
  }

  Future<void> updateSeatsAvailable(String rideId) async {
    try {
      await _supabase
          .from('rides')
          .update({'seats_available': 'seats'}) // Aktualisiere die Sitze
          .eq('id', rideId); // Filtere nach der Fahrt-ID
    } catch (e) {
      print("Fehler beim Aktualisieren der Sitze: $e");
      throw Exception("Fehler beim Aktualisieren der Sitze");
    }
  }

  Future<List<Map<String, dynamic>>> getRides(String date, String start, String stop) async {
    print("GET RIDES");
    print(date);
    String date7Days = addDaysToDateString(date, 7);
    print(date7Days);

    final response = await _supabase
        .from('rides')
        .select('id, driver_id, start_location, end_location, date, seats_available, driver:carpoolusers(first_name, avatar_url)') // Fahrer-Name direkt laden
        .gte('date', date)
        .lt('date', date7Days)
        .eq('start_location', start)
        .eq('end_location', stop)
        .order('date', ascending: true);
    print(response);
    return response ?? [];
  }

  Future<List<Map<String, dynamic>>> getRideById(String rideId) async {
    print("GET RIDE BY ID");
    print(rideId);

    final response = await _supabase
        .from('rides')
        .select('id, driver_id, start_location, end_location, date, seats_available, driver:carpoolusers(first_name)') // Fahrer-Name direkt laden
        .eq('id', rideId)
        .single(); // Da wir nur eine Fahrt zurückbekommen, verwenden wir .single()

    print(response);
    return [response] ?? []; // Rückgabe als Liste, um die gleiche Struktur wie getRides zu haben
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

  Future<int> getRideCount(String user) async {
    final response = await _supabase
        .from('rides')
        .select('count')
        .eq('driver_id', user)
        .single(); // single() sorgt dafür, dass nur ein Ergebnis zurückkommt

    return response['count'] as int? ?? 0;
  }

//   Todo: Delete and update ride

  Future<void> deleteRide(int rideId) async {
    try {
      // Lösche die Fahrt mit der angegebenen rideId
      await _supabase
          .from('rides')
          .delete()
          .eq('id', rideId); // Filtere nach der Fahrt-ID

      print("Fahrt mit ID $rideId erfolgreich gelöscht.");
      _bookingService.deleteAllBookingsForRide(rideId);
    } catch (e) {
      print("Fehler beim Löschen der Fahrt: $e");
      throw Exception("Fehler beim Löschen der Fahrt");
    }
  }

}
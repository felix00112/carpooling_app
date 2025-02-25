import 'package:supabase_flutter/supabase_flutter.dart';
import 'car_service.dart';

class BookingService{
  final SupabaseClient _supabase = Supabase.instance.client;
  final CarService _carService = CarService();

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
    await updateSeatsForRide(rideId);// nach jeder Booking Sitzplatz verringern
  }

  //ToDo: keine buchung möglich ab 0 Plätzen

  Future<void> updateSeatsForRide(int rideId) async {
    try {
      // Hol die Gesamtanzahl der Sitze aus der CarService-Methode
      int? totalSeats = await _carService.getSeats(rideId);

      if (totalSeats == null) {
        print("Fahrt $rideId: Keine Sitzplatzdaten gefunden.");
        return;
      }

      print("Total Seats for Ride $rideId: $totalSeats");

      // Hole die Anzahl der Buchungen für diese Fahrt
      final bookingResponse = await _supabase
          .from('bookings')
          .select('ride_id') // Nur die ride_id der Buchungen holen
          .eq('ride_id', rideId);

      int totalBookings = bookingResponse.length; // Anzahl der Buchungen
      print("Total Bookings for Ride $rideId: $totalBookings");

      // Berechne die verfügbaren Sitze
      int updatedSeatsAvailable = totalSeats - totalBookings;

      // Stelle sicher, dass die verfügbaren Sitze nicht negativ werden
      if (updatedSeatsAvailable < 0) {
        updatedSeatsAvailable = 0;
      }

      // Aktualisiere die Sitze in der Datenbank
      await _supabase
          .from('rides')
          .update({'seats_available': updatedSeatsAvailable}) // seats_available aktualisieren
          .eq('id', rideId);

      print("Fahrt $rideId: Verfügbare Sitzplätze aktualisiert auf $updatedSeatsAvailable");
    } catch (e) {
      print("Fehler beim Aktualisieren der Sitzplätze für Fahrt $rideId: $e");
    }
  }


  Future<void> deleteAllBookingsForRide(int rideId) async {
    try {
      final response = await _supabase
          .from('bookings')
          .delete()
          .eq('ride_id', rideId);

      print("Alle Buchungen für Fahrt $rideId wurden gelöscht.");
    } catch (e) {
      print("Fehler beim Löschen der Buchungen für Fahrt $rideId: $e");
    }
    updateSeatsForRide(rideId);
  }

  Future<void> deleteBookingForCurrentUser(int rideId) async {
    try {
      // Hole den aktuellen Benutzer
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Lösche das Booking für den aktuellen Benutzer und die gegebene Fahrt
      final response = await _supabase
          .from('bookings')
          .delete()
          .eq('ride_id', rideId) // Filtere nach der Fahrt-ID
          .eq('passenger_id', user.id); // Filtere nach der Benutzer-ID

      if (response != null) {
        print("Booking für Fahrt $rideId und Benutzer ${user.id} wurde gelöscht.");
      } else {
        print("Kein Booking gefunden für Fahrt $rideId und Benutzer ${user.id}.");
      }

      // Aktualisiere die verfügbaren Sitzplätze nach dem Löschen
      //await updateSeatsForRide(rideId);
    } catch (e) {
      print("Fehler beim Löschen des Bookings für Fahrt $rideId: $e");
      throw Exception("Fehler beim Löschen des Bookings: $e");
    }
  }




  Future<List<Map<String, dynamic>>> getBookingsForRide(int rideId) async{
    final response = await _supabase
        .from('bookings')
        .select()
        .eq('ride_id', rideId); // only bookings for given ride

    return response ?? [];
  }

}
import 'package:supabase_flutter/supabase_flutter.dart';

class CarService{
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createCar(String carName, String licensePlate, String color, int seats) async{
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw new Exception("User not logged in");
    }

    await _supabase.from('cars').insert({
      "car_name": carName,
      "license_plate": licensePlate,
      "colour": color,
      "seats": seats,
      "owner": user.id,
    });
  }

  Future<List<Map<String, dynamic>>> getCarsByUser(String userId) async {
    final response = await _supabase
        .from('cars')
        .select()
        .eq('owner', userId); // Filtere die Autos nach der owner-ID

    if (response.isEmpty) {
      return []; // Keine Autos gefunden
    }

    return List<Map<String, dynamic>>.from(response);
  }


  Future<int?> getSeats(int rideId) async {
    try {
      final response = await _supabase
          .from('cars')
          .select('seats') // Nur das Feld 'seats' abrufen
          .eq('id', rideId)
          .single();

      if (response != null && response.containsKey('seats')) {
        return response['seats'] as int; // Die Anzahl der Sitze zurückgeben
      } else {
        print("Keine Sitzplatzdaten für Ride $rideId gefunden.");
        return null;
      }
    } catch (e) {
      print("Fehler beim Abrufen der Sitze für Ride $rideId: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getCar() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw new Exception("User not logged in");
    }

    final response = await _supabase
        .from('cars')
        .select()
        .eq('owner', user.id);

    if (response.isEmpty) {
      return []; // no cars found
    }

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateCarData(Map<String, dynamic> updates) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw new Exception("User not logged in");
    }
    await _supabase
        .from('cars')
        .update(updates)
        .eq('owner', user.id);

  }

  Future<void> deleteCar(String carId) async {
    await _supabase.from('cars').delete().eq('id', carId);
  }


}
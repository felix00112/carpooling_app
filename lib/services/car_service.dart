import 'package:supabase_flutter/supabase_flutter.dart';

class CarService{
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createCar(String carName, String licensePlate, String color, int seats) async{
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw new Exception("User not logged in");
    }

    await _supabase.from('cars').insert({
      "name": carName,
      "license_plate": licensePlate,
      "color": color,
      "seats": seats,
      "owner": user.id,
    });
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

  Future<void> deleteCar(String carId) async {
    await _supabase.from('cars').delete().eq('id', carId);
  }

}
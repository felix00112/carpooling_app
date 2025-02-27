import 'package:carpooling_app/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';

class ProfileCompletionPage extends StatefulWidget {
  const ProfileCompletionPage({super.key});

  @override
  State<ProfileCompletionPage> createState() => _ProfileCompletionPageState();
}

class _ProfileCompletionPageState extends State<ProfileCompletionPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  bool _isSaving = false;

  bool isValidPhoneNumber(String phone) {
    // validation
    final RegExp phoneRegex = RegExp(r'^(?:\+)[0-9]{7,14}$');
    return phoneRegex.hasMatch(phone);
  }

  Future<void> saveUserProfile() async {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final phoneNumber = _phoneNumberController.text;


    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bitte alle Felder ausfüllen")),
      );
      return;
    }

    if (phoneNumber.isNotEmpty && !isValidPhoneNumber(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ungültige Telefonnummer. Format: +123456789")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {

      await _userService.saveUserProfile(firstName, lastName, phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null);

      if(mounted){
        Navigator.pushReplacementNamed(context, '/');
      }

    } catch (e) {
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fehler: $e")),
        );
      }
    }

    setState(() => _isSaving = false);

  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Profil vervollständigen")),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(hintText: "Vorname"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(hintText: "Nachname"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(hintText: "Telefonnummer (optional)"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveUserProfile,
                child: const Text("Speichern und fortfahren"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

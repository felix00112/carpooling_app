import 'package:flutter/material.dart';

import '../auth/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{
  //   get auth service
  final authService = AuthService();

  // text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // signup button pressed
  void signup() async{
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // check password matching
    if(password != confirmPassword) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match"))
        );
      }
      return;
    }

    // attempt signup
    try{
      await authService.signUpWithEmailAndPassword(email, password);
      Navigator.pop(context);
    }catch(e){
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: $e" ))
        );
      }
    }
  }




  @override
  Widget build(BuildContext context){
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign Up"),
        ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    hintText: "Email"
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: "Password"
                ),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: "Confirm Password"
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                  onPressed: signup,
                  child: const Text("Sign Up")
              ),
            ],
          )
      ),
    );
  }
}
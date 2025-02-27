import 'package:carpooling_app/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
//   get auth service
final authService = AuthService();

// text controllers
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

  // login button pressed
  void login() async{
    final email = _emailController.text;
    final password = _passwordController.text;
    // attempt login
    try{
      await authService.signInWithEmailAndPassword(email, password);
    }
    catch(e){
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
        title: const Text("Login"),
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

          const SizedBox(height: 20),

          ElevatedButton(
              onPressed: login,
              child: const Text("Login")
          ),

          const SizedBox(height: 5),

          GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/signup"),
              child: Center(child: Text("Don't have an account? Sign up")),
          ),

        ],
      )
    ),
  );
  }
}
/*
AUTH GATE - Continuously listen for auth state changes.
unauthenticated -> login page
authenticated -> home page
 */

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/homepage.dart';
import '../pages/login_page.dart';


class AuthGate extends StatelessWidget{
  const AuthGate ({super.key});

  @override
  Widget build(BuildContext context){
    return StreamBuilder(
        // listen to auth state changes
        stream: Supabase.instance.client.auth.onAuthStateChange,
        // build appropriate page based on auth state
        builder: (context, snapshot){
        //   loading...
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
            );
          }

        //   check if there is a valid session
          final session = snapshot.hasData ? snapshot.data!.session : null;

          if(session != null){
            return const HomePage();
          } else {
            return const LoginPage();
          }
        }
    );
  }
}
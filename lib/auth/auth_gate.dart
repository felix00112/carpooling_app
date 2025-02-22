/*
AUTH GATE - Continuously listen for auth state changes.
unauthenticated -> login page
authenticated -> home page
 */

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../pages/homepage.dart';
import '../pages/login_page.dart';
import '../pages/profile_completion_page.dart';
import '../services/user_service.dart';


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
          final userService = UserService();

          if (session != null) {
            print('user is authenticated');
            return FutureBuilder<bool>(
              future: userService.hasUserProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.data == false) {
                  print('user has no profile');
                  return const ProfileCompletionPage();
                }
                print('user has profile');
                return const HomePage();
              },
            );
          } else {
            print('user is not authenticated');
            return const LoginPage();
          }
        }
    );
  }
}
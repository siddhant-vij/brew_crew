import 'package:brew_crew/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: const Text('Sign In'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 50.0,
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 20.0),
            backgroundColor: Colors.brown[300],
            padding: const EdgeInsets.all(20.0),
            shape: const StadiumBorder(),
          ),
          onPressed: () async {
            AppUser? result = await _auth.signInAnonymously();
            if (result == null) {
              _logger.e('Error signing in');
            } else {
              _logger.i('Signed in');
              _logger.i(result.uid);
            }
          },
          child: const Text('Sign in Anonymously'),
        ),
      ),
    );
  }
}

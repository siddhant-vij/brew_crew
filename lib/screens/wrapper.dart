import 'package:flutter/material.dart';

import 'home/home.dart';
import 'auth/authenticate.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    // Return Home or Authenticate screen based on auth status.
    return const Home();
    // return const Authenticate();
  }
}

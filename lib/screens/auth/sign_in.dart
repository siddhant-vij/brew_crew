import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../services/auth.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({
    super.key,
    required this.toggleView,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final Logger _logger = Logger();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text(
                'Sign In',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(
                    Icons.person,
                  ),
                  label: const Text('Register'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: kTextInputDecoration.copyWith(
                          hintText: 'Enter your email',
                        ),
                        validator: (val) => val != null &&
                                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(val)
                            ? 'Enter a valid email'
                            : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: kTextInputDecoration.copyWith(
                          hintText: 'Enter your password',
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter a strong password';
                          }
                          String pattern =
                              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{9,}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(val)) {
                            return 'Enter a strong password.';
                          }
                          return null;
                        },
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[400],
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            final AuthResult result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result.user != null) {
                              _logger.i('Successfully signed in');
                              _logger.i(result.user!.uid);
                            } else {
                              setState(() {
                                isLoading = false;
                                error = result.errorMessage!;
                              });
                              _logger.i('Failed to sign up');
                              _logger.i(error);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

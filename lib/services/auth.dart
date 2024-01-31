import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  AppUser? _getAppUserFromFirebaseUser(User? firebaseUser) {
    return firebaseUser != null ? AppUser(uid: firebaseUser.uid) : null;
  }

  Stream<AppUser?> get userStream {
    return _auth.authStateChanges().map(_getAppUserFromFirebaseUser);
  }

  Future<AppUser?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _getAppUserFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'operation-not-allowed') {
        _logger.e('Anonymous auth hasn\'t been enabled for this project.');
      } else {
        _logger.e(e.toString());
      }
      return null;
    }
  }

  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _getAppUserFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _logger.w('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _logger.w('Wrong password provided.');
      } else if (e.code == 'invalid-email') {
        _logger.w('Invalid email provided.');
      } else if (e.code == 'user-disabled') {
        _logger.w('User for that email is disabled.');
      } else {
        _logger.e(e.toString());
      }
      return null;
    }
  }

  Future<AppUser?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _getAppUserFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _logger.w('Account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        _logger.w('The email address is not valid.');
      } else if (e.code == 'operation-not-allowed') {
        _logger.w('Email/password accounts are not enabled.');
      } else if (e.code == 'weak-password') {
        _logger.w('The password is not strong enough.');
      } else {
        _logger.e(e.toString());
      }
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      _logger.e(e.toString());
    }
  }
}

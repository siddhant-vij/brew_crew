import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../models/app_user.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  AppUser? _getAppUserFromFirebaseUser(User? firebaseUser) {
    return firebaseUser != null ? AppUser(uid: firebaseUser.uid) : null;
  }

  Stream<AppUser?> get userStream {
    return _auth.authStateChanges().map(_getAppUserFromFirebaseUser);
  }

  // Future<AuthResult> signInAnonymously() async {
  //   try {
  //     UserCredential result = await _auth.signInAnonymously();
  //     User? user = result.user;
  //     return AuthResult(user: _getAppUserFromFirebaseUser(user));
  //   } on FirebaseAuthException catch (e) {
  //     _logger.e(e.message);
  //     return AuthResult(errorMessage: e.message);
  //   }
  // }

  Future<AuthResult> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return AuthResult(user: _getAppUserFromFirebaseUser(user));
    } on FirebaseAuthException catch (e) {
      _logger.e(e.message);
      return AuthResult(errorMessage: e.message);
    }
  }

  Future<AuthResult> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseService(uid: user!.uid).updateUserData(
        name: 'New Crew Member',
        sugars: '0',
        strength: 100,
      );
      return AuthResult(user: _getAppUserFromFirebaseUser(user));
    } on FirebaseAuthException catch (e) {
      _logger.e(e.message);
      return AuthResult(errorMessage: e.message);
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

class AuthResult {
  final AppUser? user;
  final String? errorMessage;

  AuthResult({
    this.user,
    this.errorMessage,
  });
}

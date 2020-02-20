import 'package:dwimay_backend/src/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class LoginAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _currentUser;
  static LoginAuth instance;

  /// Private constructor.
  LoginAuth._();

  /// Uses firebase to log the user in using [email] and [password].
  /// Raises [Platform] exception if the entered email and password 
  /// is ""
  Future<void> login(
      {@required String email, @required String password}) async {
        
    if (email == "" || password == "") throw PlatformException;

    // logging the user in
    _currentUser = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user;
  }

  /// Registers the user, If the user document exists in firestore
  Future<void> register({@required String email, @required String password}) async {
    if (email == "" || password == "") throw PlatformException;

    // checking if the user document exists. If it exists, that means the user has paid for
    // atleast one event, and thus, can register.
    if (await (await Database.instance).exists(document: email, collection: "users")) {
      _currentUser = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    }
    else {
      throw AuthenticationError(
        type: "USER_NOT_PAID",
        message: "user has not paid for an event.",
      );
    }
  }

  /// Logs the user out.
  Future<void> logout() async {
    // setting current user to null
    _currentUser = null;

    // logging the user out
    await _firebaseAuth.signOut();
  }

  /// Checking if the user is logged in.
  /// Returns [true] if the user is logged in, [false] otherwise.
  /// Also sets the [_currentUser] value.
  Future<bool> isLoggedIn() async {
    try {
      // getting the current user
      _currentUser = await _firebaseAuth.currentUser();

      // returning [true] if [_currentUser] is not null, [false] otherwise
      return (_currentUser == null) ? false : true;

    } catch (e) {
      // returning [false] in case of error.
      return false;
    }
  }

  /// Parses and returns the claims in the login token.
  Future<Map<String, dynamic>> getClaims() async {
    // getting claims
    return Map<String, dynamic>.from(
      (await _currentUser.getIdToken()).claims
    );
  }

  /// Sends the password reset email
  Future<dynamic> sendPasswordResetEmail({@required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Gets an instance of this class. Only one
  /// instance of this class should exist.
  static LoginAuth getInstance() {
    if (instance == null) {
      instance = LoginAuth._();
    }
    return instance;
  }
}

/// class that represents an authentication error
class AuthenticationError implements Exception {
  final String type;
  final String message;

  AuthenticationError({@required this.type, this.message});
}

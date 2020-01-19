import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

/// The base class for auth states
abstract class AuthState extends Equatable {}

/// The state when the authentication is not initialized, initial state
/// The UI associated with this state is usually the splash screen
class AuthUninitialized extends AuthState {
  String toString() => "AuthenticationUninitialized";
}

/// The state when the authentication is valid.
/// The UI associated with this state is usually the home screen
class AuthValid extends AuthState {
  String toString() => "AuthenticationValid";
}

/// The state when authentication is invalid/when user has logged out/when user has not logged in
/// The UI associated with this state is usually the login screen
class AuthInvalid extends AuthState {
  String toString() => "AuthenticationInvalid";
}

/// The state when authentication is loading
class AuthLoading extends AuthState {
  String toString() => "AuthLoading";
}

/// The state when an error occurs while logging in
class AuthError extends AuthState {
  final exception;
  
  AuthError({@required this.exception});
  String toString() => "AuthError [error: ${exception.toString()}]";
}
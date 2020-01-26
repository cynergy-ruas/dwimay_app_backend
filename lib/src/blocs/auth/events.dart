import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

/// The base class for auth events
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

/// The event emitted when the app first starts
class AppStart extends AuthEvent {
  @override
  String toString() => "App started.";
}

/// The event emitted when the user attempts to log in
class LogIn extends AuthEvent {
  final String email;
  final String password;

  LogIn({@required this.email, @required this.password}) : super([email, password]);

  @override
  String toString() => "User is logging in";
}

/// The event emitted when the user attempts to register
class Register extends AuthEvent {
  final String email;
  final String password;

  Register({@required this.email, @required this.password}) : super([email, password]);

  @override
  String toString() => "User is registering";
}

/// The event emitted when the user clicks the password reset button
class PasswordResetAttempt extends AuthEvent {
  @override
  String toString() => "User is attempting to reset password";
}

/// The event emitted when the user presses the submit button after
/// providing the email to reset the password
class PasswordResetSubmit extends AuthEvent {
 final String email;

  PasswordResetSubmit({@required this.email}) : super([email]);

  String toString() => "The password reset email is being sent";
}

/// The event emitted when the user attempts to logs out
class LogOut extends AuthEvent {
  @override
  String toString() => "User is logging out";
}
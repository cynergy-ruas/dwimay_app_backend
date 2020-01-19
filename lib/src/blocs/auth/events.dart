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

/// The event emitted when the user attempts to logs out
class LogOut extends AuthEvent {
  @override
  String toString() => "User is logging out";
}
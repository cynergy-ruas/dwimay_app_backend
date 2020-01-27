import 'package:dwimay_backend/dwimay_backend.dart';

import 'states.dart';
import 'events.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dwimay_backend/src/services/auth.dart';
import 'package:dwimay_backend/src/models/user_model.dart';
import 'package:dwimay_backend/src/services/cloud_functions.dart';

// Defining the Bloc. Logic goes here

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  LoginAuth _auth = LoginAuth.getInstance();

  final NotificationBloc notificationBloc;

  AuthBloc({@required this.notificationBloc});

  @override
  AuthState get initialState => AuthUninitialized();

  /// Maps auth events to auth states.
  /// The function takes the event emitted [AuthEvent] and  
  /// yields a new [AuthState] as a response to the [AuthEvent].
  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    
    // checks if the user is logged in or not. If the user has logged 
    // in already, yield [AuthValid] state. if not, yield [AuthInvalid]
    // state.
    if (event is AppStart) {
      // yield uninitialized state first, since nothing has happened yet
      yield AuthUninitialized();

      // getting current user
      var user = User.instance;

      // checking if user is already logged in
      if (await _auth.isLoggedIn()) {
        // if the user is logged in, set the claims
        user.setClaims(await _auth.getClaims());

        // yield [AuthValid] state
        yield AuthValid();
      }
      else
        // user has not logged in, yield AuthInvalid
        yield AuthInvalid();
    }

    // if the user is trying to log in
    else if (event is LogIn) {
      // yield loading state
      yield AuthLoading();
      

      try{
        // logging the user in
        await _auth.login(email: event.email, password: event.password);

        // setting claims
        User.instance.setClaims(await _auth.getClaims());

        // subscribing user to events based on clearance levels
        _subscribeOrUnsubscribeFromEvents(notificationBloc.subscribe);

        // yield [AuthValid] state
        yield AuthValid();
      }
      catch (e) {
        // error occured while logging in, yield [AuthError] state
        yield AuthError(exception: e);
        // yielding [AuthInvalid] state
        yield AuthInvalid();
      }
    }

    else if (event is Register) {
      // yielding loading state
      yield AuthLoading();

      // attempt registration
      bool res = await CloudFunctions.instance.registerUser(email: event.email, password: event.password);

      // if the registration was unsuccessful, then
      if (! res) {

        // yielding error event
        yield AuthError(exception: Exception("User has not paid for an event."));

        // yielding login screen
        yield AuthInvalid();
      }
      else {
        
        try {
          // logging the user in
          await _auth.login(email: event.email, password: event.password);

          // setting claims
          User.instance.setClaims(await _auth.getClaims());

          // subscribing user to events based on clearance levels
          _subscribeOrUnsubscribeFromEvents(notificationBloc.subscribe);

          // yielding event to show the home page
          yield AuthValid();
        }
        catch (e) {
          // yielding the event to show the error
          yield AuthError(exception: e);

          // yielding the event to show the login screen
          yield AuthInvalid();
        }
      }
    }

    // if the user is trying to reset password
    else if (event is PasswordResetAttempt) {

      // yeilding form
      yield AuthPasswordReset();
    }

    // if the user submits the email to reset the password
    else if (event is PasswordResetSubmit) {
      yield AuthLoading();

      try {
        // attempting to send password reset mail
        await _auth.sendPasswordResetEmail(email: event.email);

        // yielding state to show success message
        yield AuthPasswordResetSuccess();

        // yielding login form
        yield AuthInvalid();
      }

      catch (e) {
        // yielding error state
        yield AuthError(exception: e);
        
        // yielding login form
        yield AuthInvalid();
      }
    }

    // The back button is pressed to go back to the login form
    else if (event is Back) {
      yield AuthInvalid();
    }

    // if the user is trying to log out
    else {
      // yield loading state
      yield AuthLoading();

      // logging out
      await _auth.logout();

      // unsubscribing user to events based on clearance levels
      _subscribeOrUnsubscribeFromEvents(notificationBloc.unsubscribe);

      // yield [AuthInvalid] state
      yield AuthInvalid();
    }
  }

  /// Subscribes user to events based on clearance levels
  void _subscribeOrUnsubscribeFromEvents(void Function({String topic}) action) {
    // subscribing user to events based on clearance level
    // if the user is a normal user
    if (User.instance.getClearanceLevel() == 0) {
      for (String id in User.instance.regEventIDs)
       action(topic: id);
    }

    // if the user is a level 1 (coordinator/volunteer) or a level 2 (lead)
    else if (User.instance.getClearanceLevel() == 1 || User.instance.getClearanceLevel() == 2)
      action(topic: User.instance.getEventId());

    // if the user is a level 3+ user
    else {
      for (Department dep in Department.values) 
        action(topic: dep.id);
      
    }

    // subscribing to general topic
    action(topic: "general");
  }

  /// Logs the user in.
  void login({@required String email, @required String password}) => 
    this.add(LogIn(email: email, password: password));

  /// Registers the user.
  void register({@required String email, @required String password}) =>
    this.add(Register(email: email, password: password));

  /// Logs the user out.
  void logout() => this.add(LogOut());

  /// starts the password reset process
  void startResetPassword() => this.add(PasswordResetAttempt());

  /// attempts a password reset submission
  void resetPassword({@required String email}) => this.add(PasswordResetSubmit(email: email));

  /// goes back to login form
  void showLoginForm() => this.add(Back());
}

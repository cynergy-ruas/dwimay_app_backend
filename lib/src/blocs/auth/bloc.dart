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

  /// Function to get the device token
  final String Function() getDeviceToken;

  AuthBloc({@required this.getDeviceToken});

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

    // if the user is trying to log out
    else {
      // yield loading state
      yield AuthLoading();

      // logging out
      await _auth.logout();

      // yield [AuthInvalid] state
      yield AuthInvalid();
    }
  }

  /// Logs the user in.
  void login({@required String email, @required String password}) => 
    this.add(LogIn(email: email, password: password));

  /// Registers the user.
  void register({@required String email, @required String password}) =>
    this.add(Register(email: email, password: password));

  /// Logs the user out.
  void logout() => this.add(LogOut());
  
}

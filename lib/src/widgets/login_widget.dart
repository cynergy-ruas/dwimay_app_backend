import 'package:dwimay_backend/src/blocs/auth/bloc.dart';
import 'package:dwimay_backend/src/blocs/auth/events.dart';
import 'package:dwimay_backend/src/blocs/auth/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget that display login UI and logs a person 
/// in.
class LoginWidget extends StatefulWidget {

  /// Widget to be displayed when login screen has not
  /// been loaded. (typically a splash screen)
  final Widget onUninitialized;

  /// Widget to be displayed when login process is on going
  final Widget onLoading;

  /// Widget to be displayed when login process is complete and 
  /// successful
  final Widget onSuccess;

  /// The login UI
  final Widget loginForm;

  /// Callback to execute when login error occurs.
  final void Function(BuildContext, dynamic) onError;

  /// The bloc to use
  final AuthBloc bloc;

  LoginWidget({Key key, this.onUninitialized, @required this.loginForm, @required this.onLoading,
               @required this.onSuccess, @required this.onError, @required this.bloc})
  : super(key: key);

  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {

  // getting parameters from [widget]
  Widget get onUninitialized => widget.onUninitialized;
  Widget get onLoading => widget.onLoading;
  Widget get onSuccess => widget.onSuccess;
  Widget get loginForm => widget.loginForm;
  void Function(BuildContext, dynamic) get onError => widget.onError;

  @override
  void initState() {
    super.initState();
    widget.bloc.add(AppStart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: widget.bloc,

      // listening for errors.
      listener: (BuildContext context, AuthState state) {
        // if there is an error,
        if (state is AuthError)
          // execute [onError] callback
          onError(context, state.exception);
      },

      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: widget.bloc,

        // building UI based on state
        builder: (BuildContext context, AuthState state) {
          Widget child;

          // if the state is uninitalized, show [onUninitialized]
          // (typically splash screen)
          if (state is AuthUninitialized) {
            child = onUninitialized ?? Container();
          }

          // [loginForm], if state is [AuthInvalid]
          else if (state is AuthInvalid) {
            child = loginForm;
          }

          // authentication is valid, navigating to 
          // [onSuccess] widget
          else if (state is AuthValid) {
            child = onSuccess;
          }

          // loading screen
          else {
            child = onLoading;
          }

          return AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: child
          );
        },
      ),
    );
  }
}
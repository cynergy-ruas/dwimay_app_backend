import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dwimay_backend/blocs/auth_bloc.dart';

class LoginExample extends StatefulWidget {
  @override
  _LoginExampleState createState() => _LoginExampleState();
}

class _LoginExampleState extends State<LoginExample> {
  /// the [AuthBloc]
  final AuthBloc _authBloc = new AuthBloc();

  @override
  void initState() {
    super.initState();
    // dispatching app start event
    _authBloc.add(AppStart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Example"),
      ),
      // BlocProvider to provide the [AuthBloc] later in the widget tree
      body: BlocProvider(
        create: (BuildContext context) => _authBloc,

        // BlocListener listens for error states, as [SnackBar]
        // can only be shown in a BlocListener, not BlocBuilder
        child: BlocListener<AuthBloc, AuthState>(
          bloc: _authBloc,
          listener: (BuildContext context, AuthState state) {
            // error has occured, showing snackbar
            if (state is AuthError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  backgroundColor: Colors.red,
                )
              );
              print(state.error);
            }
          },

          // BlocBuilder for the other states
          child: BlocBuilder<AuthBloc, AuthState>(
            bloc: _authBloc,
            builder: (BuildContext context, AuthState state) {
              Widget child; 
              // if the state is uninitalized, show splash screen
              if (state is AuthUninitialized) {
                child = SplashScreen();
              }

              // login form, if state is [AuthInvalid]
              else if (state is AuthInvalid) {
                child = Padding(
                    padding: EdgeInsets.all(20),
                    child: LoginPage()
                  );
              }

              // authentication is valid, navigating to 
              // home page
              else if (state is AuthValid) {
                child = HomePage(authBloc: _authBloc,);
              }

              // loading screen
              else {
                child = LoadingWidget();
              }

              return AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: child
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  final AuthBloc authBloc;

  HomePage({@required this.authBloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Home page"),
        SizedBox(height: 40,),
        RaisedButton(
          child: Text("Log out"),
          onPressed: () {
            authBloc.add(LogOut());
          },
        ),
      ],
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Building login form");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'username'),
            controller: _usernameController,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'password'),
            controller: _passwordController,
            obscureText: true,
          ),
          RaisedButton(
            onPressed: () {
              print(BlocProvider.of<AuthBloc>(context));
              BlocProvider.of<AuthBloc>(context).add(
                LogIn(
                  email: _usernameController.text.trim(),
                  password: _passwordController.text
                )
              );
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.3,
          child: ModalBarrier(dismissible: false, color: Colors.grey[300])
        ),
        Center(
          child: SizedBox(
            height: 60,
            width: 60,
            child: new CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          )
        )
      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Splash Screen"
      ),
    );
  }
}



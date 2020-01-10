import 'package:dwimay_backend/dwimay_backend.dart';
import 'package:flutter/material.dart';

class LoginExample extends StatefulWidget {
  @override
  _LoginExampleState createState() => _LoginExampleState();
}

class _LoginExampleState extends State<LoginExample> {
  /// Key to access the [LoginWidget]. Used to execute
  /// login and logout
  GlobalKey<LoginWidgetState> loginKey = GlobalKey<LoginWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Example"),
      ),
      
      // using a [Builder] widget so that snackbars can be 
      // shown.
      body: LoginWidget(
        key: loginKey,

        // widget to display when the login screen is not loaded
        onUninitialized: SplashScreen(),

        // widget to display when the login process is on going
        onLoading: LoadingWidget(),

        // widget to display when the login process was successful
        onSuccess: HomePage(),

        // the login form
        loginForm: LoginPage(),

        // callback to execute when an error occurs during the 
        // authentication process
        onError: (BuildContext context, Exception e) => Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${e.toString()}'),
            backgroundColor: Colors.red,
          )
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Home page"),
        SizedBox(height: 40,),
        RaisedButton(
          child: Text("Log out"),
          onPressed: () => LoginWidget.of(context).logout(),
        ),
      ],
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("Building login form");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'username'),
            controller: emailController,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'password'),
            controller: passwordController,
            obscureText: true,
          ),
          RaisedButton(
            onPressed: () => LoginWidget.of(context).login(
              email: emailController.text,
              password: passwordController.text
            ),
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



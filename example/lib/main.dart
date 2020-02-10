import 'package:dwimay_backend/dwimay_backend.dart';
import 'package:example/event_load.dart';
import 'package:example/login.dart';
import 'package:example/notifications.dart';
import 'package:example/qr.dart';
import 'package:example/user_info_load.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // adding the backend provider
    return BackendProvider(
      townscriptAPIToken: "eyJhbGciOiJIUzUxMiJ9.eyJST0xFIjoiUk9MRV9VU0VSIiwic3ViIjoic2h5YW1hbnQuYWNoYXJAZ21haWwuY29tIiwiYXVkaWVuY2UiOiJ3ZWIiLCJjcmVhdGVkIjoxNTgxMTYwNzAwMjE2LCJVU0VSX0lEIjoxOTA2MzAxLCJleHAiOjE1ODg5MzY3MDB9.xStPTuyUvqIAZx6fgAMq8o_nvAQo7r3Hkq6_XUFQPdHLvvKfTVxl3cnPFVZx4bV-YptBOacnqDOoY-Iv2_tmqg",
      onMessage: (BuildContext context, Map<String, dynamic> message) {
        // showing overlay
        return SafeArea(
          child: Card(
            child: Text(message.toString()),
          ),
        );
      },

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TechFest Backend Example"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Event load example"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EventLoadExample()
                        )
                      );
                    },
                  ),
                  SizedBox(height: 30,),

                  RaisedButton(
                    child: Text("Login example"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginExample()
                        )
                      );
                    },
                  ),
                  SizedBox(height: 30,),
                  
                  RaisedButton(
                    child: Text("Notifications example"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NotificationsExample()
                        )
                      );
                    },
                  ),
                  SizedBox(height: 30,),
                  
                  RaisedButton(
                    child: Text("QR example"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QrExample()
                        )
                      );
                    },
                  ),

                  SizedBox(height: 30,),
                  
                  RaisedButton(
                    child: Text("Townscript API example"),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserInfoLoadExample()
                        )
                      );
                    },
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
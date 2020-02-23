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
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // adding the backend provider
    return BackendProvider(
      townscriptAPIToken: "eyJhbGciOiJIUzUxMiJ9.eyJST0xFIjoiUk9MRV9VU0VSIiwic3ViIjoiYWFkaHlhcnVhc0BnbWFpbC5jb20iLCJhdWRpZW5jZSI6IndlYiIsImNyZWF0ZWQiOjE1ODEzNDg2NTMyNzksIlVTRVJfSUQiOjE5MTA3ODYsImV4cCI6MTU4OTEyNDY1M30.VfscQvCeIpNu4_d5Cx9RGtX3vaQ9nXmroxGQ3YfqgTwYfQCDpIoMbiTMhjxIoMSkqnSRRqM81mjCK2Fl5ABpDw",
      onMessage: (BuildContext context, Announcement announcement) {
        // showing overlay
        return SafeArea(
          child: Card(
            child: Text(announcement.toString()),
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
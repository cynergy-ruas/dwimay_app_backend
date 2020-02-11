import 'package:dwimay_backend/dwimay_backend.dart';
import 'package:flutter/material.dart';

class UserInfoLoadExample extends StatefulWidget {
  @override
  _UserInfoLoadExampleState createState() => _UserInfoLoadExampleState();
}

class _UserInfoLoadExampleState extends State<UserInfoLoadExample> {

  GlobalKey<UsersLoaderWidgetState> _key = GlobalKey<UsersLoaderWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UsersLoaderWidget(
        key: _key,
        beginLoad: false,
        eventId: "test-140110",
        onUninitialized: Center(
          child: RaisedButton(
            child: Text("start"),
            onPressed: () {
              print(_key.currentState);
              _key.currentState.beginLoadingData(eventId: "test-140110");
            },
          ),
        ),

        onLoading: Center(child: CircularProgressIndicator(),),

        onLoaded: (BuildContext context, List<AttendeeInfo> data) =>
          ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) => 
              ListTile(title: Text(data[index].registrationId),),
          )
      ),
    );
  }
}
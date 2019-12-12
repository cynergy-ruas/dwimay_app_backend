import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dwimay_backend/blocs/notification_bloc.dart';
import 'package:dwimay_backend/services/notifications.dart';

class NotificationsExample extends StatefulWidget {
  @override
  _NotificationsExampleState createState() => _NotificationsExampleState();
}

class _NotificationsExampleState extends State<NotificationsExample> {

  FirebaseNotifications _notifications;

  _NotificationsExampleState() {
    // this line initializes the notifications and asks the required
    // permissions from the user (for iOS)
    this._notifications = FirebaseNotifications.instance;

    // this line configures what should happen when a notification is 
    // recieved during various scenarios like when the app is closed
    // ([onLaunch]), when the app is in the background ([onResume])
    // and when the app is in foreground ([onMessage])
    this._notifications.configureCallbacks(
      onLaunch: onLaunch,
      onResume: onResume,
      onMessage: onMessage
    );
  }

  List<Widget> pages;
  int currentPage;

  @override
  void initState() {
    super.initState();
    pages = [page1(), page2()];
    currentPage = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications Test"),
      ),

      // A [BlocListener] is used since a [Snackbar] has to be shown
      // when a notification is recieved. When a notification is recieved,
      // the notification service adds a [NotificationRecieved] event 
      // to the [NotificationBloc]. The [NotificationBloc] recieves this
      // event and emits a [ShowNotificationUI] state, which is used
      // to show an appropriate UI to the user.
      body: BlocListener<NotificationBloc, NotificationState>(
        bloc: _notifications.notificationBloc,
        listener: (BuildContext context, NotificationState state) {
          if (state is ShowNotificationUI) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("notification recieved! ${state.message}"),
              )
            );
          }
        },

        // the rest of the app
        child: pages[currentPage],
      ),

      // normal [BottomNavigationBar] stuff
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Container()
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Container()
          )
        ]
      ),
    );
  }

  Widget page1() {
    return Builder(
      builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Home"),
                SizedBox(height: 40),
                RaisedButton(
                  child: Text("Subscribe to test event"),
                  onPressed: () {
                    _notifications.subscribeToTopic("t12")
                    .then((value) => Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Subscribed"),)
                    ));
                  },
                ),
                SizedBox(height: 40,),
                RaisedButton(
                  child: Text("Unsubscribe from test event"),
                  onPressed: () {
                    _notifications.unsubscribeFromTopic("t12")
                    .then((value) => Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Unsubscribed"),)
                    ));
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  Widget page2() {
    return Center(
      child: Text("Profile"),
    );
  }

  /// Defines what should happen when a notification is recieved
  /// when the app is in foreground
  void onMessage({@required Map<String, dynamic> message}) {
    setState(() {
      currentPage = 0;
    });
  }

  /// Defines what should happen when a notification is recieved
  /// when the app is in background
  void onResume({@required Map<String, dynamic> message}) {
    setState(() {
      currentPage = 0;
    });
  }

  /// Defines what should happen when a notification is recieved 
  /// when the app is not running.
  void onLaunch({@required Map<String, dynamic> message}) {
    setState(() {
      currentPage = 0;
    });
  }
}
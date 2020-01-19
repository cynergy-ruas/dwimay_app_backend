import 'package:dwimay_backend/dwimay_backend.dart';
import 'package:flutter/material.dart' hide NotificationListener;

class NotificationsExample extends StatefulWidget {
  @override
  _NotificationsExampleState createState() => _NotificationsExampleState();
}

class _NotificationsExampleState extends State<NotificationsExample> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications Test"),
      ),

      body: page1(),
    );
  }

  /// Random home page
  Widget page1() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // gap
          SizedBox(height: 20,),

          // title
          Text("Home"),

          // gap
          SizedBox(height: 40),
          
          // button to subscribe to notifications of event
          SubscribeButton(),

          // gap
          SizedBox(height: 40,),

          // button to unsubscribe to notifications of event
          UnsubscribeButton(),

          // gap
          SizedBox(height: 40,),

          // button to clear announcements
          DeleteButton(),

          // gap
          SizedBox(height: 40,),
          
          // title
          Text("announcements:"),

          // gap
          SizedBox(height: 40,),

          // the previous announcements
          Expanded(
            child: AnnouncementsBuilder(
              builder: (BuildContext context, List<Announcement> announcements) {
                return ListView.builder(
                  itemCount: announcements.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: ValueKey(announcements[index]),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        padding: EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.delete)
                          ],
                        ),
                      ),
                      child: ListTile(
                        title: Text(announcements[index].title),
                        subtitle: Text(announcements[index].body),
                      ),
                      onDismissed: (DismissDirection direction) =>
                        BackendProvider.of<NotificationBloc>(context).removeFromPool(index: index),
                    );
                  },
                );
              },
            )
          ),

          // gap
          SizedBox(height: 20,),

          // button to publish notification
          PublishButton(),

          // gap
          SizedBox(height: 20,)
        ],
      )
    );
  }
}

/// Button to publish notification
class PublishButton extends StatelessWidget {
  const PublishButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Publish Notification"),
      onPressed: () {
        CloudFunctions.instance.publishNotification(
          topic: "t12",
          announcement: Announcement.fromRaw(
            title: "Title!",
            body: "Body!!",
            data: {
              "description": "Some long description"
            }
          )
        );
      },
    );
  }
}

/// Button to subscribe to notifications for events. 
/// In a separate widget so that [NotificationListener.of] can 
/// work properly.
class SubscribeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Subscribe to test event"),
      onPressed: () {
        BackendProvider.of<NotificationBloc>(context).subscribe(topic: "t12")
        .then((value) => Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Subscribed"),)
        ));
      },
    );
  }
}

/// Button to unsubscribe from notifications for events. 
/// In a separate widget so that [NotificationListener.of] can 
/// work properly.
class UnsubscribeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Unsubscribe from test event"),
      onPressed: () {
        BackendProvider.of<NotificationBloc>(context).unsubscribe(topic: "t12")
        .then((value) => Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Unsubscribed"),)
        ));
      },
    );
  }
}

/// Button to clear events. In a separate widget so 
/// that [NotificationListener.of] can work properly.
class DeleteButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Clear announcements"),
      onPressed: () {
        BackendProvider.of<NotificationBloc>(context).deleteAll()
        .then((_) => Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Deleted all announcements."),)
        ));
      },
    );
  }
}
import 'package:dwimay_backend/dwimay_backend.dart';
import 'package:dwimay_backend/src/blocs/notifications/bloc.dart';
import 'package:dwimay_backend/src/blocs/notifications/states.dart';
import 'package:dwimay_backend/src/services/notifications.dart';
import 'package:flutter/material.dart' hide NotificationListener;
import 'package:flutter_bloc/flutter_bloc.dart';

/// Provides a notification stream and builds the widget (or whatever is provided)
/// when the app is in foreground. This widget should be at the root of every widget
/// tree for the notifications to be received and the appropriate UI to be shown.
class NotificationListener extends StatefulWidget {

  /// Builder function that builds the UI when a notification arrives
  final Widget Function(BuildContext, Announcement) onMessage;

  /// Callback to execute when a notification arrives when the application
  /// is in background. If not given, resumes the app by default.
  final NotificationCallback onResume;

  /// Callback to execute when a notification arrives and the application
  /// is not open. If not given, launches the app by default.
  final NotificationCallback onLaunch;

  /// A child widget
  final Widget child;

  /// The bloc to use
  final NotificationBloc bloc;

  const NotificationListener({@required this.bloc, @required this.onMessage, this.onResume, this.onLaunch, this.child});

  @override
  _NotificationListenerState createState() => _NotificationListenerState();
}

class _NotificationListenerState extends State<NotificationListener> {

  @override
  void initState() {
    super.initState();

    // Configuring callbacks to execute when notification arrives
    // and providing the bloc to use when a notification arrives
    // when the app is in foreground
    FirebaseNotificationSettings.instance.configure(
      bloc: widget.bloc,
      onResume: widget.onResume,
      onLaunch: widget.onLaunch
    );
  }

  @override
  Widget build(BuildContext context) {

    // A [BlocListener] is used to execute [onMessage] as the UI to be shown
    // is assumed to be an alert, snackbar, a navigation, etc.
    // When a notification is recieved, the notification service 
    // (configured using [FirebaseNotificationSettings] in [initState]) adds 
    // a [NotificationRecieved] event to the [NotificationBloc]. 
    // The [NotificationBloc] receives this event and emits a 
    // [ShowNotificationUI] state, which is used to show an appropriate 
    // UI to the user.
    return BlocListener<NotificationBloc, NotificationState>(
      bloc: widget.bloc,
      listener: (BuildContext context, NotificationState state) {
        if (state is ShowNotificationUI) 
          showOverlayNotification((context) => 
            Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.up,
              child: widget.onMessage(context, state.announcement),
              onDismissed: (DismissDirection direction) => 
                OverlaySupportEntry.of(context).dismiss(animate: false),
            )
          );
      },
      child: widget.child,
    );
  }
}
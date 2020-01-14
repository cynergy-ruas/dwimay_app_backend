import 'package:dwimay_backend/blocs/notification_bloc.dart';
import 'package:dwimay_backend/managers/announcement_manager.dart';
import 'package:dwimay_backend/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Provides a notification stream and builds the widget (or whatever is provided)
/// when the app is in foreground. This widget should be at the root of every widget
/// tree for the notifications to be received and the appropriate UI to be shown.
class NotificationsListener extends StatefulWidget {

  /// Builder function that builds the UI when a notification arrives
  final void Function(BuildContext, Map<String, dynamic>) onMessage;

  /// Callback to execute when a notification arrives when the application
  /// is in background. If not given, resumes the app by default.
  final NotificationCallback onResume;

  /// Callback to execute when a notification arrives and the application
  /// is not open. If not given, launches the app by default.
  final NotificationCallback onLaunch;

  /// A child widget
  final Widget child;

  const NotificationsListener({@required this.onMessage, this.onResume, this.onLaunch, this.child});

  @override
  _NotificationsListenerState createState() => _NotificationsListenerState();

  /// Used to obtain the [NotificationsServices] object (an [InheritedWidget])
  /// that is present higher up in the widget tree. The [NotificationsServices]
  /// object can be used to subscribe to events and unsubscribe from events.
  static NotificationsServices of(BuildContext context) => 
    context.dependOnInheritedWidgetOfExactType(aspect: NotificationsServices);
}

class _NotificationsListenerState extends State<NotificationsListener> {

  /// The [NotificationBloc]
  NotificationBloc _bloc;

  /// The manager to handle announcements
  AnnouncementManager _manager;

  @override
  void initState() {
    super.initState();

    // initializing manager
    _manager = AnnouncementManager();

    // initializing bloc
    _bloc = NotificationBloc(manager: _manager);

    // loading announcenments from local storage
    _bloc.add(NotificationInit());

    // Configuring callbacks to execute when notification arrives
    // and providing the bloc to use when a notification arrives
    // when the app is in foreground
    FirebaseNotificationSettings.instance.configure(
      bloc: _bloc,
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
    return NotificationsServices(
      manager: _manager,
      child: BlocListener<NotificationBloc, NotificationState>(
        bloc: _bloc,
        listener: (BuildContext context, NotificationState state) {
          if (state is ShowNotificationUI) 
            widget.onMessage(context, state.message);
        },
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}

/// Provides additional services of firebase cloud messaging, such 
/// as subscribing to a topic, unsubscribing from a topic, clearing
/// local storage of announcements, etc.
class NotificationsServices extends InheritedWidget {

  /// The manager
  final AnnouncementManager manager;

  NotificationsServices({@required this.manager, Widget child}) : super(child: child);

  /// Subscribes device to a given topic
  Future<void> subscribe({@required String topic}) =>
     FirebaseNotificationSettings.instance.subscribeToTopic(topic: topic);


  /// Unsubscribes device from a given topic
  Future<void> unsubscribe({@required String topic}) =>
    FirebaseNotificationSettings.instance.unsubscribeFromTopic(topic: topic);
  
  /// Clears announcements/notifications from local storage and pool
  Future<void> deleteAll() => manager.delete();

  /// Removes a single announcement from local storage and pool
  Future<void> delete({@required int index}) => manager.remove(index: index);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
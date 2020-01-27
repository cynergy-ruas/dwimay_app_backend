import 'package:dwimay_backend/src/blocs/auth/bloc.dart';
import 'package:dwimay_backend/src/blocs/event/bloc.dart';
import 'package:dwimay_backend/src/blocs/notifications/bloc.dart';
import 'package:flutter/material.dart' hide NotificationListener;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:overlay_support/overlay_support.dart';

import 'notification_listener.dart';

/// The widget that provides various facilities.
/// **Has** to be the root widget of the whole
/// app for the backend to work correctly.
class BackendProvider extends StatefulWidget {

  /// The child widget. Usually the app
  final Widget child;

  /// The listeners for notifications
  final List<void Function(Map<String, dynamic>)> notificationListeners;

  /// Builder function that builds the UI when a notification arrives
  final void Function(BuildContext, Map<String, dynamic>) onMessage;

  BackendProvider({@required this.child, @required this.onMessage, this.notificationListeners = const []});

  @override
  _BackendProviderState createState() => _BackendProviderState();

  static T of<T extends Bloc<dynamic, dynamic>>(BuildContext context) =>
    BlocProvider.of<T>(context);

  // adds a notification listener
  static addNotificationListener(BuildContext context, void Function(Map<String, dynamic>) listener) =>
    BackendProvider.of<NotificationBloc>(context).addListener(listener);
}

class _BackendProviderState extends State<BackendProvider> {

  /// The notifications bloc
  NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();

    // initializing the notification bloc
    _notificationBloc = NotificationBloc();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: NotificationListener(
        bloc: _notificationBloc,
        onMessage: widget.onMessage,
        child: MultiBlocProvider(
        providers: [
          BlocProvider<EventLoadBloc>(
            create: (context) => EventLoadBloc(),
          ),

          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              notificationBloc: _notificationBloc
            ),
          ),

          BlocProvider<NotificationBloc>(
            create: (context) => _notificationBloc
          )
        ],

        child: widget.child,
      ),
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _notificationBloc.close();
  }
}
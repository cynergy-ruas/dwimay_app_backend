import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:dwimay_backend/blocs/notification_bloc.dart';

typedef void Callback({@required Map<String, dynamic> message});

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  NotificationBloc notificationBloc;

  static FirebaseNotifications _instance;

  FirebaseNotifications._() {
    // creating bloc
    notificationBloc = NotificationBloc();

    // creating object
    _firebaseMessaging = FirebaseMessaging();

    // requesting for permissions
    if (Platform.isIOS) 
      _iOSPermission();

    // printing token
    _firebaseMessaging.getToken().then((token) {
      print("token: $token");
    });
  }

  /// Configures callbacks that should be executed when a notification arrives.
  void configureCallbacks({@required Callback onResume, @required Callback onLaunch, Callback onMessage}) {
    // configuring callbacks that should be executed when a notification
    // arrives
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        notificationBloc.add(NotificationReceived(message: message));
        
        if (onMessage != null)
          onMessage(message: message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        onResume(message: message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        onLaunch(message: message);
      },
    );
  }

  /// Subscribes device to a given topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Ubsubscribes device from current topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  /// Requests permission from user to send notifications (iOS only).
  void _iOSPermission() {

    // requesting permission    
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));

    // listening for confirmation
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  /// Returns an instance of the class which handles 
  /// firebase notifications.
  static FirebaseNotifications get instance {
    if (_instance == null) {
      _instance = FirebaseNotifications._();
    }

    return _instance;
  }
}


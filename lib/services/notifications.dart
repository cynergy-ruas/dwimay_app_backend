import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:dwimay_backend/blocs/notification_bloc.dart';

typedef void NotificationCallback({@required Map<String, dynamic> message});

/// Used to configure firebase cloud messaging
class FirebaseNotificationSettings {
  FirebaseMessaging _messaging;

  static FirebaseNotificationSettings _instance;

  FirebaseNotificationSettings._() {
    // creating object
    _messaging = FirebaseMessaging();

    // requesting for permissions
    if (Platform.isIOS) 
      _iOSPermission();

    // printing token
    _messaging.getToken().then((token) {
      print("token: $token");
    });
  }

  /// Configures callbacks that should be executed when a notification arrives.
  void configure({@required NotificationCallback onResume, @required NotificationCallback onLaunch, 
                  @required NotificationBloc bloc}) {

    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async => bloc.add(NotificationReceived(message: message)),
      onResume: (Map<String, dynamic> message) async => onResume(message: message),
      onLaunch: (Map<String, dynamic> message) async => onLaunch(message: message),
    );
  }

  /// Requests permission from user to send notifications (iOS only).
  void _iOSPermission() {

    // requesting permission    
    _messaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));

    // listening for confirmation
    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("iOS notification settings registered: $settings");
    });
  }

  /// Returns an instance of the class which handles 
  /// firebase notifications.
  static FirebaseNotificationSettings get instance {
    if (_instance == null) {
      _instance = FirebaseNotificationSettings._();
    }

    return _instance;
  }

  /// Subscribes device to topic
  Future<void> subscribeToTopic({@required String topic}) => 
    _messaging.subscribeToTopic(topic);

  /// Unsubscribes device to topic
  Future<void> unsubscribeFromTopic({@required String topic}) => 
    _messaging.unsubscribeFromTopic(topic);

}

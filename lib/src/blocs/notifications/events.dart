import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

/// The base class for notification events
abstract class NotificationEvent extends Equatable {
  NotificationEvent([List props = const []]) : super(props);
}

/// The event emitted when the bloc is initialized
class NotificationInit extends NotificationEvent {
  String toString() => "Notification Init";
}

/// The event emitted when a notification is received when the app is in
/// foreground
class NotificationReceivedForeground extends NotificationEvent { 
  final Map<String, dynamic> message;

  NotificationReceivedForeground({@required this.message});

  @override
  String toString() => "Notification Received Foreground";
}

/// The event emitted when a notification is received when the app is in 
/// background or closed
class NotificationReceivedBackground extends NotificationEvent {
  final Map<String, dynamic> message;

  NotificationReceivedBackground({@required this.message});

  @override
  String toString() => "Notification Recevied Background";
}
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

/// The event emitted when a notification is received
class NotificationReceived extends NotificationEvent { 
  final Map<String, dynamic> message;

  NotificationReceived({@required this.message});

  @override
  String toString() => "Notification Received";
}
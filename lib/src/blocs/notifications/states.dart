import 'package:dwimay_backend/src/models/announcement_model.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

/// The base class for notification events
abstract class NotificationState extends Equatable {
  NotificationState([List props = const []]) : super(props);
}

/// The initial state
class NotificationUninitialized extends NotificationState {
  @override
  String toString() => "Notification uninitialized state";
}

/// The state to transit to when a notification occurs.
/// This state signals that an appropriate UI should be shown.
class ShowNotificationUI extends NotificationState {
  final Announcement announcement;

  ShowNotificationUI({@required this.announcement});

  @override
  String toString() => "Showing notification UI";
}
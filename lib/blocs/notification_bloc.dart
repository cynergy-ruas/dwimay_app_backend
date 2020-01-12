import 'package:bloc/bloc.dart';
import 'package:dwimay_backend/dwimay_backend.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Defining the events

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

// Defining the states

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
  final Map<String, dynamic> message;

  ShowNotificationUI({@required this.message});

  @override
  String toString() => "Showing notification UI";
}

// Defining the Bloc. Logic goes here

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {

  final AnnouncementManager manager;

  NotificationBloc({@required this.manager});

  @override 
  NotificationState get initialState => NotificationUninitialized();

  /// Maps notification events to states.
  /// The function yields a [ShowNotificationUI] state when
  /// A notification ([NotificationRecieved]) occurs to signal 
  /// the app to show the appropriate UI.
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {

    // if notifications are initialized, load all notifications
    // from local storage
    if (event is NotificationInit)
      manager.load();

    if (event is NotificationReceived) {
      // yeilding event to show the appropriate UI
      yield ShowNotificationUI(message: event.message);

      // adding the notification to the pool and local storage
      manager.update(payload: event.message);

      yield initialState;
    }
  }
}


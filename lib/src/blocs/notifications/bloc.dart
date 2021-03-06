import 'package:dwimay_backend/src/models/announcement_model.dart';
import 'package:dwimay_backend/src/services/file_provider.dart';
import 'package:dwimay_backend/src/services/notifications.dart';

import 'states.dart';
import 'events.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {

  List<void Function(Map<String, dynamic>)> listeners;

  NotificationBloc({List<void Function(Map<String, dynamic>)> listeners = const []}) {
    this.listeners = List<void Function(Map<String, dynamic>)>()
                     ..addAll(listeners);
    loadAnnouncementsFromStorage();
  }
  

  @override 
  NotificationState get initialState => NotificationUninitialized();

  /// Maps notification events to states.
  /// The function yields a [ShowNotificationUI] state when
  /// A notification ([NotificationRecieved]) occurs to signal 
  /// the app to show the appropriate UI.
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {

    if (event is NotificationReceivedForeground) {
      // adding notification messages to pool
      // such messages are announcements
      if (event.message.containsKey("notification") || event.message.containsKey("aps")) {
        Announcement a = this.addToPool(payload: event.message);

        // yielding event to show the appropriate UI
        yield ShowNotificationUI(announcement: a);
      }
      
      // notifying listeners
      listeners.forEach((listener) => listener(event.message));

      yield initialState;
    }

    /// when the notification is received when the app is in background
    else if (event is NotificationReceivedBackground) {
      // adding notification messages to pool
      // such messages are announcements
      if (event.message.containsKey("notification") || event.message.containsKey("aps"))
        this.addToPool(payload: event.message);
    }

    /// when the notification is received when the app is closed
    else if (event is NotificationReceivedClosed) {
      // loading the announcements from storage
      await loadAnnouncementsFromStorage();

      // adding notification messages to pool
      // such messages are announcements
      if (event.message.containsKey("notification") || event.message.containsKey("aps"))
        this.addToPool(payload: event.message);
    }
    
  }

  // Operations related to [FirebaseNotificationSettings]

  /// Subscribes device to a given topic
  Future<void> subscribe({@required String topic}) =>
     FirebaseNotificationSettings.instance.subscribeToTopic(topic: topic);


  /// Unsubscribes device from a given topic
  Future<void> unsubscribe({@required String topic}) =>
    FirebaseNotificationSettings.instance.unsubscribeFromTopic(topic: topic);

  /// Returns the firebase cloud message device token
  String getDeviceToken() => 
    FirebaseNotificationSettings.instance.deviceToken;

  // Operations related to handling announcements:

  /// Loads the announcements from local storage.
  Future<void> loadAnnouncementsFromStorage() async {
    // getting instance of [FileProvider]
    FileProvider _instance = await FileProvider.instance;

    // clearing the pool
    AnnouncementPool.instance.clear();

    // populating the pool with [Announcement] objects by loading
    // the data from local storage and converting each of the loaded
    // data into an [Announcement] object.
    AnnouncementPool.instance.addAll(
      announcements: (await _instance.loadAnnouncements()).map<Announcement>(
        (a) => Announcement.fromStorage(map: a)
      ).toList()
    );
  }

  /// Adds an announcement to the [AnnouncementPool] and the local storage.
  Announcement addToPool({@required Map<String, dynamic> payload}) {  
    // creating an [Announcement] object
    Announcement a = Announcement.fromMap(map: payload);

    // adding [Announcement] object to [AnnouncementPool]
    AnnouncementPool.instance.add(announcement: a);

    // updating local storage
    FileProvider.instance.then((instance) {
        instance.dumpAnnouncments(
          data: AnnouncementPool.instance.raws
        );
      }
    );

    return a;
  }

  /// Removes announcement from [AnnouncementPool] and updates local storage.
  Future<void> removeFromPool({@required Announcement announcement}) {

    // removing from [AnnouncementPool]
    AnnouncementPool.instance.remove(announcement: announcement);

    // updating local storage
    return FileProvider.instance.then((instance) => 
      instance.dumpAnnouncments(
        data: AnnouncementPool.instance.raws
      )
    );
  }

  /// Clears [AnnouncementPool] and deletes announcements from
  /// local storage:
  Future<void> deleteAll() {
    // clearing [AnnouncementPool]
    AnnouncementPool.instance.clear();

    // deleting from local storage
    return FileProvider.instance.then((instance) => instance.deleteAnnouncements());
  }

  // operations related to the bloc

  /// Adds a listener
  void addListener(void Function(Map<String, dynamic>) listener) => this.listeners.add(listener);
}


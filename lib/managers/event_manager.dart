import 'package:dwimay_backend/managers/manager.dart';
import 'package:meta/meta.dart';
import 'package:dwimay_backend/models/events_model.dart';
import 'package:dwimay_backend/services/database.dart';

/// Loads the event data using the database API and stores it
/// in the [EventPool]
class EventManager extends Manager{

  Future<void> load() async {
    // getting instance of database
    Database db = await Database.instance;

    // getting raw information about all events
    List<Map<String, dynamic>> data = await db.getAllEvents();

    // clearing the events from the [EventPool]
    EventPool.clearEvents();

    // creating variable to store datetimes
    List<DateTime> datetimes;

    // creating events and updating [EventPool]
    for (int i = 0; i < data.length; i++) {
      // skipping the template document present
      // in the database
      if (data[i]["docRef"] == "template")
        continue;

      datetimes = data[i]["datetimes"].map((timestamp) => timestamp.toDate()).toList().cast<DateTime>();

      // checking the smallest date in the dates of all the events
      // to get the start day of the fest
      datetimes.forEach((date) {
        if (Event.festFirstDay == null || Event.festFirstDay.isAfter(date))
          Event.festFirstDay = date;
      });

      EventPool.addEvent(Event(
        datetimes: datetimes,
        department: data[i]["department"],
        description: data[i]["description"],
        id: data[i]["id"],
        name: data[i]["name"],
        speaker: data[i]["speaker"],
        type: data[i]["type"],
        venue: data[i]["venue"],
        documentID: data[i]["docRef"]
      ));
    }
  }

  /// Updates an event referenced by [documentID] with the values given as arguments.
  void updateEvent({@required Event event, List<DateTime> datetimes, String department,
    String description, String name, String speaker, String type, String venue}) async {
      
    // modifying event object if the given parameter is not null
    // and if its not same as the old one.
    if (datetimes != null && event.datetimes != datetimes)
      event.datetimes = datetimes;
    if (department != null && event.department != department)
      event.department = department;
    if (description != null && event.description != description)
      event.description = description;
    if (name != null && event.name != name)
      event.name = name;
    if (speaker != null && event.speaker != speaker)
      event.speaker = speaker;
    if (type != null && event.type != type)
      event.type = type;
    if (venue != null && event.venue != venue)
      event.venue = venue;

    // getting instance of database
    Database db = await Database.instance;

    // updating event
    await db.updateEvent(event: event);
  }

  /// Deletes an event.
  Future<void> deleteEvent({@required Event event}) async {
    // getting instance of database
    Database db = await Database.instance;

    // deleting the event
    await db.deleteEvent(event: event);
  }
}
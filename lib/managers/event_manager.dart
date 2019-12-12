import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwimay_backend/models/events_model.dart';
import 'package:dwimay_backend/services/database.dart';

class EventManager {
  /// Loads the event data using the database API and stores it
  /// in the [EventPool]

  Future <void> loadData() async {
    // getting instance of database
    Database db = await Database.instance;

    // getting raw information about all events
    List<Map<String, dynamic>> data = await db.getAllEvents();

    // creating events and updating [EventPool]
    for (int i = 0; i < data.length; i++) {
      EventPool.addEvent(Event(
        datetime: data[i]["datetime"],
        department: data[i]["department"],
        description: data[i]["description"],
        id: data[i]["id"],
        name: data[i]["name"],
        speaker: data[i]["speaker"],
        type: data[i]["type"],
        venue: data[i]["venue"]
      ));
    }
  }

  /// Updates an event referenced by [documentID] with the values given as arguments.
  Future<void> updateEvent({@required Event event, DateTime datetime, String department,
    String description, String name, String speaker, String type, String venue}) async {
      
    // modifying event object if the given parameter is not null
    // and if its not same as the old one.
    if (datetime != null && event.datetime != Timestamp.fromDate(datetime))
      event.datetime = Timestamp.fromDate(datetime);
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
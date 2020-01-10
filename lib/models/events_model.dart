import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event {
  /// Date and time of the event.
  Timestamp datetime;

  /// The department conducting the event.
  String department;

  /// The description of the event.
  String description;

  /// The ID of the event
  String id;

  /// The name of the event.
  String name;

  /// The speaker of the event.
  String speaker;

  /// The type of the event.
  String type;
  
  /// The venue of the event.
  String venue;

  /// The document id of the firebase document containing
  /// the event's information.
  String documentID;

  Event({
    @required this.datetime,
    @required this.department,
    @required this.description,
    @required this.id,
    @required this.name,
    @required this.speaker,
    @required this.type,
    @required this.venue,
    this.documentID
  });


  String toString(){
    return "Event[Name: $name]";
  }

  /// Formats [datetime]. Example: "Tuesday, March 26, 2019"
  String getLongDate(){
    return DateFormat.yMMMMEEEEd().format(datetime.toDate());
  }

  /// Formats [datetime]. Example: "26th March, 2019"
  String getShortDate() {
    DateTime _date = this.datetime.toDate();
    
    String day = DateFormat.d().format(_date);
    String daySuffix = "th";
    if (day.endsWith("1")) daySuffix = "st";
    else if (day.endsWith("2")) daySuffix = "nd";
    else if (day.endsWith("3")) daySuffix = "rd";

    return day + daySuffix + " " + 
           DateFormat.MMMM().format(_date) + ", " +
           DateFormat.y().format(_date); 
  }

  /// Formats [datetime]. Example 2:00 pm
  String getTime() {
    return DateFormat.jm().format(datetime.toDate());
  }

  /// Sets the documentID.
  void setDocumentID(String documentID) {
    this.documentID = documentID;
  } 
}

class EventPool {
  static List<Event> events = [];

  /// Sets the events in the [EventPool] to the one provided 
  /// in the argument.
  static void setEvents(List<Event> events) {
    EventPool.events = events;
  }

  /// Adds the [event] to the [EventPool]
  static void addEvent(Event event) {
    EventPool.events.add(event);
  }

  /// Clears all the [event]s in the list
  static void clearEvents() {
    EventPool.events = [];
  }
}

class Department {
  static const String AerospaceAndAutomotive = "ASE";
  static const String ComputerScience = "CSE";
  static const String ElectricAndElectronics = "ECE";
  static const String Design = "DS";
  static const String Mechanical = "ME";
  static const String All = "All";
}

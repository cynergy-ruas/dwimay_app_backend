import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

class Event {
  /// variable to store the first day of the fest
  static DateTime festFirstDay;

  /// Date and time of the event.
  List<DateTime> datetimes;

  /// The department conducting the event.
  String department;

  /// The description of the event.
  String description;

  /// The ID of the event
  String id;

  /// The name of the event.
  String name;

  /// The contact information of the POC of the event
  Map<String, String> poc;

  /// The speaker of the event.
  String speaker;

  /// The type of the event.
  String type;
  
  /// The venue of the event.
  String venue;

  /// The registration link
  String registrationLink;

  /// The document id of the firebase document containing
  /// the event's information.
  String documentID;

  Event({
    @required this.datetimes,
    @required this.department,
    @required this.description,
    @required this.id,
    @required this.name,
    @required this.poc,
    @required this.speaker,
    @required this.type,
    @required this.venue,
    this.registrationLink,
    this.documentID
  });


  String toString(){
    return "Event[Name: $name]";
  }

  /// Formats [datetimes]. Example: 
  /// "26th March, 2019", if [requireYear] is true,
  /// "Tuesday, 26th March" if [requireDay] is true,
  /// "Tuesday, 26th March, 2019" if [requireYear] and [requireDay]
  /// both are true.
  String formatDate({bool requireYear = false, bool requireDay = false, int index = 0}) {
    DateTime _date = this.datetimes[index];
    
    String date = DateFormat.d().format(_date);
    String dateSuffix = "th";
    if (date.endsWith("1")) dateSuffix = "st";
    else if (date.endsWith("2")) dateSuffix = "nd";
    else if (date.endsWith("3")) dateSuffix = "rd";

    return ((requireDay) ?
           DateFormat.EEEE().format(_date) + ", " : "") + 
           date + dateSuffix + " " + 
           DateFormat.MMMM().format(_date) + 
           ((requireYear) ? ", " + DateFormat.y().format(_date) : ""); 
  }

  /// Formats [datetimes]. Example 2:00 pm
  String getTime({int index = 0}) {
    return DateFormat.jm().format(datetimes[index]);
  }

  /// Checks whether the event is on mulitple days or not.
  bool isMultiDayEvent() => (datetimes.length == 1) ? false : true;

  /// Sets the documentID.
  void setDocumentID(String documentID) {
    this.documentID = documentID;
  } 

  /// Helper function to get day 'x' events of a fest
  static List<Event> getEventsOfDay({@required int day, List<Event> events}) {
    if (events == null)
      events = EventPool.events;

    // defining variables to store the events
    List<Event> res = List<Event>();
    
    // defining variable to store the duration
    Duration duration = Duration(days: day - 1);

    // for every event
    for (int i = 0; i < events.length; i++) {

      // for all the dates the event will occur on
      for (int j = 0; j < events[i].datetimes.length; j++)
      
        // if a date of the event matches the first day + duration, add the event to [res]
        if (Event.festFirstDay.toUtc().add(duration).day == events[i].datetimes[j].toUtc().day) {
          res.add(events[i]);
          break;
        }
    }

    return res;
  }

  /// Gets the name of the poc
  String getPocName() => poc["name"];

  /// Gets the phone number of the poc
  String getPocNumber() => poc["number"];
}

/// Contains all the events.
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

/// constants to identify department
enum Department {
  AerospaceAndAutomotive,
  All,
  ComputerScience,
  Civil,
  Design,
  ElectricAndElectronics,
  Mechanical,
}

/// Extension to the [Department] enum.
extension DepartmentExtras on Department {

  /// The raw data related to each enum value
  static const data = {
    Department.AerospaceAndAutomotive: {
      "id": "ASE",
      "name": "Aeronautical and Automotive",
    },

    Department.All: {
      "id": "ALL",
      "name": "All Departments",
    },

    Department.ComputerScience: {
      "id": "CSE",
      "name": "Computer Science",
    },

    Department.Civil: {
      "id": "CE",
      "name": "Civil"
    },

    Department.Design: {
      "id": "DS",
      "name": "Design",
    },

    Department.ElectricAndElectronics: {
      "id": "ECE",
      "name": "Electrical and Electronics",
    },

    Department.Mechanical: {
      "id": "ME",
      "name": "Mechanical",
    },
  };

  /// gets the id of the department
  String get id =>
    DepartmentExtras.data[this]["id"];

  /// gets the name of the department
  String get name =>
    DepartmentExtras.data[this]["name"];

  /// gets the id from the name of the department
  static String getIdFromName(String name) =>
    DepartmentExtras.data.values.firstWhere(
      (info) => info["name"] == name,
    )["id"];

  /// gets the name from the id of the department
  static String getNameFromId(String id) => 
    DepartmentExtras.data.values.firstWhere(
      (info) => info["id"] == id,
    )["name"];
}

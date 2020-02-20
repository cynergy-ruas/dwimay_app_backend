import 'package:bloc/bloc.dart';
import 'package:dwimay_backend/src/models/events_model.dart';
import 'package:dwimay_backend/src/models/pass_model.dart';
import 'package:dwimay_backend/src/services/database.dart';
import 'events.dart';
import 'states.dart';
import 'package:meta/meta.dart';

class EventLoadBloc extends Bloc<DataLoadEvent, DataLoadState>{

  @override
  DataLoadState get initialState => DataLoadUnintialized();

  /// Maps [DataLoadEvent]s to [DataLoadState]s. Yields a [DataLoadState] in 
  /// response to the [DataLoadEvent].
  @override
  Stream<DataLoadState> mapEventToState(DataLoadEvent event) async* {
    if (event is BeginDataLoad) {
      // yielding data load on going
      yield DataLoadOnGoing();

      // loading data
      try {
        List<dynamic> res = await Future.wait([this._loadEvents(), this._loadPasses()]);

        // yielding data load complete state
        yield DataLoadComplete(
          events: List<Event>.from(res[0]),
          passes: List<Pass>.from(res[1])
        );
      } 
      catch (e) {
        yield DataLoadError(exception: e);
        yield initialState;
      }
    }

    else if (event is UpdateData) {

      try {
        await this._updateEvent(
          event: event.event,
          datetimes: event.datetimes,
          department: event.department,
          description: event.description,
          name: event.name,
          speaker: event.speaker,
          type: event.type,
          venue: event.venue,
          registrationLink: event.registrationLink
        );

        yield DataLoadComplete(
          events: EventPool.events
        );
      }
      catch (e) {
        yield DataLoadError(exception: e);
        yield initialState;
      }
    }
  }

  /// Loads the passes
  Future<List<Pass>> _loadPasses() async =>
    await (await Database.instance).getPasses();

  Future<List<Event>> _loadEvents() async {
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
        poc: Map<String, String>.from(data[i]["poc"]),
        speaker: data[i]["speaker"],
        type: data[i]["type"],
        venue: data[i]["venue"],
        registrationLink: data[i]["registrationLink"],
        documentID: data[i]["docRef"]
      ));
    }

    return EventPool.events;
  }

  /// Updates an event referenced by [documentID] with the values given as arguments.
  Future<void> _updateEvent({@required Event event, List<DateTime> datetimes, String department,
    String description, String name, String speaker, String type, String venue, String registrationLink}) async {
      
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
    if (registrationLink != null && event.registrationLink != registrationLink)
      event.registrationLink = registrationLink;

    // getting instance of database
    Database db = await Database.instance;

    // updating event
    return await db.updateEvent(event: event);
  }  
}

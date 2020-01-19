import 'package:flutter/material.dart';
import 'package:dwimay_backend/dwimay_backend.dart';

class EventLoadExample extends StatefulWidget {
  @override
  _EventLoadExampleState createState() => _EventLoadExampleState();
}

class _EventLoadExampleState extends State<EventLoadExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Load Example"),
      ),
      body: Center(
        // using a [Builder] widget so that snackbars can be 
        // shown.
        child: EventLoader(
          bloc: BackendProvider.of<EventLoadBloc>(context),

          // widget to display when the event loading has not begun.
          onUninitialized: LoadButton(),

          // widget to display when the event loading is going on.
          onLoading: CircularProgressIndicator(),

          // widget to display when the events are loaded.
          onLoaded: (List<Event> events) {
            events = Event.getEventsOfDay(day: 3, events: events);
            print(events);
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                Event event = events[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text(event.description),
                );
              },
            );
          },

          onError: (BuildContext context, dynamic e) => Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${e.toString()}'),
              backgroundColor: Colors.red,
            )
          ),
        ),
      ),
    );
  }
}

class LoadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Load events"),
      onPressed: () { 
        BackendProvider.of<EventLoadBloc>(context).add(BeginDataLoad());
      },
    );
  }
}
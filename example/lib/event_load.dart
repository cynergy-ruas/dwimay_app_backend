import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dwimay_backend/blocs/data_load_bloc.dart';
import 'package:dwimay_backend/managers/event_manager.dart';
import 'package:dwimay_backend/models/events_model.dart';

class EventLoadExample extends StatefulWidget {
  @override
  _EventLoadExampleState createState() => _EventLoadExampleState();
}

class _EventLoadExampleState extends State<EventLoadExample> {

  /// The [DataLoadBloc]
  final DataLoadBloc _bloc = DataLoadBloc(manager: EventManager());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Load Example"),
      ),
      body: Center(
        // BlocListener listens for error states, as [SnackBar]
        // can only be shown in a BlocListener, not BlocBuilder
        child: BlocListener<DataLoadBloc, DataLoadState>(
          bloc: _bloc,
          listener: (BuildContext context, DataLoadState state) {
            if (state is DataLoadError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  backgroundColor: Colors.red,
                )
              );
              print(state.error);
            }
          },
          // BlocBuilder for the other states
          child: BlocBuilder<DataLoadBloc, DataLoadState>(
            bloc: _bloc,
            builder: (BuildContext context, DataLoadState state) {
              // if its the initial state of data load, show button to 
              // load data
              if (state is DataLoadUnintialized) {
                return RaisedButton(
                  child: Text("Load events"),
                  onPressed: onPress,
                );
              }

              // if the loading is in progress, show loading bar
              else if (state is DataLoadOnGoing) {
                return CircularProgressIndicator();
              }

              // if the data is loaded, list it
              else {
                return ListView.builder(
                  itemCount: EventPool.events.length,
                  itemBuilder: (BuildContext context, int index) {
                    Event event = EventPool.events[index];
                    return ListTile(
                      title: Text(event.name),
                      subtitle: Text(event.description),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void onPress() {
    _bloc.add(BeginDataLoad());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}
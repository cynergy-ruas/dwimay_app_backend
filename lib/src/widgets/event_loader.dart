import 'package:dwimay_backend/src/blocs/event/bloc.dart';
import 'package:dwimay_backend/src/blocs/event/events.dart';
import 'package:dwimay_backend/src/blocs/event/states.dart';
import 'package:dwimay_backend/src/models/events_model.dart';
import 'package:dwimay_backend/src/models/pass_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget that loads and displays the events.
class EventLoader extends StatefulWidget {
  /// callback to execute when exception occurs.
  final void Function(BuildContext, dynamic) onError;

  /// Widget to display when the data is loading
  final Widget onLoading;

  /// Widget to display when the data is not loaded
  final Widget onUninitialized;

  /// Function that returns the widget to display when
  /// the data is loaded. The [List<Event>] provided as an 
  /// argument is empty if the client (phone) is not 
  /// connected to the internet.
  final Widget Function(List<Event>, List<Pass>) onLoaded;

  /// Specifies whether to begin loading the data
  /// immediately. If false (default is false), the 
  /// [loadData] method should be called externally.
  final bool beginLoad;

  /// The bloc to use
  final EventLoadBloc bloc;

  EventLoader({
    Key key,
    this.bloc,
    this.onUninitialized,
    @required this.onLoading, 
    @required this.onLoaded,
    this.onError,
    this.beginLoad = false
  }) : super(key: key);

  @override
  EventLoaderState createState() => EventLoaderState();
}

class EventLoaderState extends State<EventLoader> {
  
  // getting the parameters from widget
  bool get beginLoad => widget.beginLoad;
  Widget get onUninitialized => widget.onUninitialized;
  Widget get onLoading => widget.onLoading;
  Widget Function(List<Event>, List<Pass>) get onLoaded => widget.onLoaded;
  void Function(BuildContext, dynamic) get onError => widget.onError;

  /// The bloc. Used if [widget.bloc] is null
  EventLoadBloc _bloc;

  @override
  void initState() {
    super.initState();

    // initializing the event load bloc
    _bloc = (widget.bloc != null) ? widget.bloc : EventLoadBloc();
    if (beginLoad)
      _bloc.add(BeginDataLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventLoadBloc, DataLoadState> (
      bloc: _bloc,

      // listening for errors.
      listener: (BuildContext context, DataLoadState state) {
        // if there is an error,
        if (state is DataLoadError)
          // execute [onError] callback
          onError?.call(context, state.exception);
      },

      child: BlocBuilder<EventLoadBloc, DataLoadState> (
        bloc: _bloc,

        // building widget based on other states
        builder: (BuildContext context, DataLoadState state) {
          // the widget to show
          Widget child;

          // if the data load is not started,
          if (state is DataLoadUnintialized) {
            child = onUninitialized ?? Container();
          }
          
          // if the data is loading,
          else if (state is DataLoadComplete)
            child = onLoaded(state.events, state.passes);

          // if the data is loaded,
          else
            child = onLoading;

          return AnimatedSwitcher(
            duration: Duration(milliseconds: 250),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    // disposing bloc if the bloc was created here
    if (widget.bloc == null) 
      _bloc.close();
  }
}
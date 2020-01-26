import 'package:dwimay_backend/src/blocs/registered_events/bloc.dart';
import 'package:dwimay_backend/src/blocs/registered_events/states.dart';
import 'package:dwimay_backend/src/blocs/registered_events/events.dart';
import 'package:dwimay_backend/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Loads the registered events for a user.
class RegisteredEventsLoader extends StatefulWidget {

  /// The widget to display when the event loading has not started.
  final Widget initWidget;

  /// The widget to display when the registered events are loading
  final Widget onLoading;

  /// The function to execute when all the registered events are loaded
  final Widget Function(BuildContext, List<String>) onLoaded;

  /// The function to execute when an error occurs
  final void Function(BuildContext, dynamic) onError;

  const RegisteredEventsLoader({
    Key key,
    this.onError,
    this.initWidget, 
    @required this.onLoading,
    @required this.onLoaded, 
  }) : super(key: key);

  @override
  _RegisteredEventsLoaderState createState() => _RegisteredEventsLoaderState();
}

class _RegisteredEventsLoaderState extends State<RegisteredEventsLoader> {

  /// The bloc
  RegisteredEventsBloc _bloc;

  @override
  void initState() {
    super.initState();

    // initializing bloc
    _bloc = RegisteredEventsBloc();

    // starting the loading process
    _bloc.add(BeginRegEventsLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisteredEventsBloc, RegEventsState>(
      bloc: _bloc,
      listener: (BuildContext context, RegEventsState state) {
        // checking if an error occurred in the bloc. If so, execute error
        // callback
        if (state is RegEventsError)
          widget.onError?.call(context, state.error);
      },
      child: BlocBuilder<RegisteredEventsBloc, RegEventsState>(
        bloc: _bloc,
        builder: (BuildContext context, RegEventsState state) {

          Widget _body;

          // checking if state is initial state
          if (state is RegEventsInit)
            _body = widget.initWidget ?? Container();

          // checking if state is loading state
          if (state is RegEventsLoading)
            _body = widget.onLoading;

          // checking if state is loaded state
          else
            _body = widget.onLoaded(context, User.instance.regEventIDs);

          return AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: _body,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    // closing bloc
    _bloc.close();
  }
}
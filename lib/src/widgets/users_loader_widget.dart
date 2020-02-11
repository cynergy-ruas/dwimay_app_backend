import 'package:dwimay_backend/src/blocs/load_user_info/bloc.dart';
import 'package:dwimay_backend/src/blocs/load_user_info/events.dart';
import 'package:dwimay_backend/src/blocs/load_user_info/states.dart';
import 'package:dwimay_backend/src/models/attendee_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget that loads the attendee information of an event
/// and constructs a UI based on it.
class UsersLoaderWidget extends StatefulWidget {

  /// The id of the event whose attendee data has to be loaded
  final String eventId;

  /// Widget to display when loader is not initialized
  final Widget onUninitialized;

  /// Widget to display when data is loading
  final Widget onLoading;

  /// Function to execute when error occurs
  final void Function(BuildContext, dynamic) onError;

  /// Function to execute when data is loaded
  final Widget Function(BuildContext, List<AttendeeInfo>) onLoaded;

  /// Boolean that defines whether data load should happen immediately
  final bool beginLoad;

  /// Boolean that defines whether attendee information about the passes
  /// should also be loaded
  final bool includePasses;

  UsersLoaderWidget({
    Key key,
    @required this.onLoaded,
    this.onLoading,
    this.onUninitialized,
    this.onError,
    this.eventId,
    this.beginLoad = true,
    this.includePasses = false
  })
    : assert(! (beginLoad == true && eventId == null)),
      super(key: key);

  @override
  UsersLoaderWidgetState createState() => UsersLoaderWidgetState();
}

class UsersLoaderWidgetState extends State<UsersLoaderWidget> {

  UserInfoLoadBloc _bloc;

  @override
  void initState() {
    super.initState();

    // initializing the bloc
    _bloc = UserInfoLoadBloc();

    // starting load if defined so
    if (widget.beginLoad)
      _bloc.add(BeginUserDataLoad(eventCode: widget.eventId, includePasses: widget.includePasses));

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoLoadBloc, DataLoadState>(
      bloc: _bloc,
      // listening for errors
      listener: (BuildContext context, DataLoadState state) {
        if (state is DataLoadError)
          widget.onError?.call(context, state.exception);
      },

      child: BlocBuilder<UserInfoLoadBloc, DataLoadState>(
        bloc: _bloc,
        builder: (BuildContext context, DataLoadState state) {
          Widget body;

          // if the state is uninitialized state, set the appropriate UI
          if (state is DataLoadUnintialized)
            body = widget.onUninitialized ?? Container();

          // if the state is complete state, construct and set the appropriate UI
          else if (state is DataLoadComplete)
            body = widget.onLoaded(context, state.data);

          // if the state is loading state, set the appropriate UI
          else 
            body = widget.onLoading ?? Container();

          return AnimatedSwitcher(
            child: body,
            duration: Duration(milliseconds: 250),
          );
        },
      ),
    );
  }

  void beginLoadingData({@required String eventId, bool includePasses = false}) =>
    _bloc.add(BeginUserDataLoad(eventCode: eventId, includePasses: includePasses));

  @override
  void dispose() {
    super.dispose();

    // closing bloc
    _bloc.close();
  }
}
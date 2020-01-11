import 'package:dwimay_backend/blocs/data_load_bloc.dart';
import 'package:dwimay_backend/managers/announcement_manager.dart';
import 'package:dwimay_backend/models/announcement_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The widget that builds the UI that displays the 
/// [Announcement]s. Widget rebuilds whenever the 
/// [AnnouncementPool] is updated.
class AnnouncementsBuilder extends StatefulWidget {

  /// The function that builds the widget
  final Widget Function(BuildContext, List<Announcement>) builder; 

  /// The function that is called when an error occurs
  final void Function(BuildContext, dynamic) onError;

  /// Widget to be displayed when data is loading
  final Widget onLoading;

  AnnouncementsBuilder({Key key, @required this.builder, this.onError,
  this.onLoading = const Center(child: CircularProgressIndicator(),)})
  : super(key: key);

  @override
  AnnouncementsBuilderState createState() => AnnouncementsBuilderState();
}

class AnnouncementsBuilderState extends State<AnnouncementsBuilder> {

  /// The bloc which handles announcement events
  DataLoadBloc _bloc;

  /// The manager that handles loading and updating 
  /// announcements
  AnnouncementManager _manager;

  @override
  void initState() {
    super.initState();

    // initializing manager
    _manager = AnnouncementManager();

    // initializing bloc
    _bloc = DataLoadBloc(manager: _manager);

    // loading announcements from local storage
    _bloc.add(BeginDataLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataLoadBloc, DataLoadState>(
      bloc: _bloc,

      // listening for errors
      listener: (BuildContext context, DataLoadState state) {
        if (state is DataLoadError)
          widget.onError?.call(context, state.exception);
      },

      // building UI
      child: BlocBuilder<DataLoadBloc, DataLoadState> (
        bloc: _bloc,
        builder: (BuildContext context, DataLoadState state) {
          // if data load has not started or is on going
          if (state is DataLoadUnintialized || state is DataLoadOnGoing)
            return widget.onLoading;
          
          // if data is loaded
          else
            return widget.builder(context, AnnouncementPool.announcements);
        },
      ),
    );
  }

  /// clears announcments
  Future<void> clear() =>
    // deleting events and updating UI
    _manager.delete().then((_) => _bloc.add(BeginDataLoad()));
  

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }
}

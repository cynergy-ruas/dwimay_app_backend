import 'package:meta/meta.dart';
import 'package:dwimay_backend/src/models/events_model.dart';
import 'package:equatable/equatable.dart';

/// The base class for data load events
abstract class DataLoadEvent extends Equatable {
  DataLoadEvent([List props = const []]) : super(props);
}

/// The event emitted when data loading is initiated
class BeginDataLoad extends DataLoadEvent {
  @override
  String toString() => "BeginDataLoad";
}

/// The event emitted when data is to be updated
class UpdateData extends DataLoadEvent {

  final Event event;
  final List<DateTime> datetimes;
  final String department;
  final String description;
  final String name;
  final String speaker;
  final String type;
  final String venue;

  UpdateData({
    @required this.event,
    @required this.datetimes,
    @required this.department,
    @required this.description,
    @required this.name,
    @required this.speaker, 
    @required this.type,
    @required this.venue
  });

  @override
  String toString() => "UpdateData[Event: $event]";
}
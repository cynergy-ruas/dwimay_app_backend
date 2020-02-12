import 'package:dwimay_backend/src/models/registered_event.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

/// Base class for registered events states
abstract class RegEventsState extends Equatable {}

/// The initial state
class RegEventsInit extends RegEventsState {
  @override
  String toString() => "RegisteredEventsInit";
}

/// The loading state
class RegEventsLoading extends RegEventsState {
  @override
  String toString() => "RegisteredEventsLoading";
}

/// The state when the loading is completed
class RegEventsLoaded extends RegEventsState {

  final List<RegisteredEvent> regEvents;

  RegEventsLoaded({@required this.regEvents});

  @override
  String toString() => "RegisteredEventsLoaded";
}

/// The state when an error occurs while loading the registered
/// events
class RegEventsError extends RegEventsState {
  final dynamic error;

  RegEventsError({@required this.error});

  @override
  String toString() => "RegisteredEventsError[${error.toString()}]";
}
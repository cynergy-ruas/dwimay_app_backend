import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

/// The base class for registered events events
abstract class RegEventsEvent extends Equatable {
  RegEventsEvent([List props = const []]) : super(props);
}

/// The event to begin loading the registered events of a user
class BeginRegEventsLoad extends RegEventsEvent {
  final String email;

  BeginRegEventsLoad({@required this.email});

  @override
  String toString() => "BeginRegisteredEventsLoad";
}
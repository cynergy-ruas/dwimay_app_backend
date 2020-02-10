import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

/// The base class for data load events
abstract class UserDataLoadEvent extends Equatable {
  UserDataLoadEvent([List props = const []]) : super(props);
}

/// The event emitted when data loading is initiated
class BeginUserDataLoad extends UserDataLoadEvent {
  
  final String eventCode;

  BeginUserDataLoad({@required this.eventCode});

  @override
  String toString() => "BeginDataLoad";
}
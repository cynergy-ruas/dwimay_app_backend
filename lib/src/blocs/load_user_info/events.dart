import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

/// The base class for data load events
abstract class UserDataLoadEvent extends Equatable {
  UserDataLoadEvent([List props = const []]) : super(props);
}

/// The event emitted when data loading is initiated
class BeginUserDataLoad extends UserDataLoadEvent {
  
  /// The id of the event who's data is to be loaded
  final String eventCode;

  /// Defining whether to include passes or not
  final bool includePasses;

  BeginUserDataLoad({@required this.eventCode, @required this.includePasses});

  @override
  String toString() => "BeginDataLoad";
}
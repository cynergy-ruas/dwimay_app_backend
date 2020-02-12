import 'package:meta/meta.dart';

class RegisteredEvent {
  /// The id of the event / pass
  final String id;

  /// boolean that defines whether it is a pass or not
  final bool isPass;

  /// The list of event names that are part of the pass
  final List<String> eventNames;

  RegisteredEvent({@required this.id, this.eventNames, this.isPass = false}) : 
    assert(!isPass || (isPass && eventNames != null));
  
}
import 'package:meta/meta.dart';

class RegisteredEvent {
  /// The id of the event / pass
  final String id;

  /// boolean that defines whether it is a pass or not
  final bool isPass;

  /// The registration id of the pass
  final String registrationId;

  /// The list of event names that are part of the pass
  final List<String> eventNames;

  RegisteredEvent({@required this.id, this.eventNames, this.registrationId, this.isPass = false}) : 
    assert(!isPass || (isPass && eventNames != null && registrationId != null));
  
}
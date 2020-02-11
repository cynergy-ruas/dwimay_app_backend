/// Information of the attendees obtained from townscript API
class AttendeeInfo {
  /// The event code of the event which the user registered for
  String eventCode;

  /// The email id of the event
  String email;

  /// The name of the user
  String name;

  /// The townscript registration id
  String registrationId;

  AttendeeInfo.fromJson(Map<String, dynamic> json) {
    this.eventCode = json["eventCode"];
    this.email = json["userEmailId"];
    this.name = json["userName"];
    this.registrationId = json["registrationId"].toString();
  }

  @override
  String toString() =>
    "AttendeeInfo[email: $email, registrationId: $registrationId]";
}
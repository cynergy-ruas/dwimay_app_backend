import 'package:dwimay_backend/src/models/townscript_form_answer.dart';

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

  /// The list of answers
  List<TownscriptFormAnswer> answerList;

  AttendeeInfo.fromJson(Map<String, dynamic> json) {
    this.eventCode = json["eventCode"];
    this.email = json["userEmailId"];
    this.name = json["userName"];
    this.registrationId = json["registrationId"].toString();
    this.answerList = List<TownscriptFormAnswer>.from(json["answerList"]?.map((answer) => TownscriptFormAnswer.fromJson(answer))?.toList() ?? []);
  }

  /// Gets all the answers of all the questions separated by [separator]
  String getAllAnswers({String separator = ","}) =>
    answerList.map((qa) => qa.answer).toList().join(separator);

  @override
  String toString() =>
    "AttendeeInfo[email: $email, registrationId: $registrationId]";
}
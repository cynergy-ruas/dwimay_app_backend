/// Models an answer in the [answerList] parameter received from
/// Townscript
class TownscriptFormAnswer {
  /// The question
  String question;

  /// The answer. In case of multiple choice, the answers are 
  /// separated with a comma
  String answer;

  /// The id
  String id;

  TownscriptFormAnswer.fromJson(Map<String, String> json) {
    this.question = json["question"];
    this.answer = json["answer"];
    this.id = json["uniqueQuestionId"];
  }
}
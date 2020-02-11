import 'package:meta/meta.dart';

/// Represents a pass
class Pass {
  /// The name of the pass
  String name;

  /// The id of the pass
  String id;

  /// The description of the pass
  String description;

  /// The link of the pass
  String registrationLink;

  Pass({@required this.name, @required this.id, @required this.description, @required this.registrationLink});

  Pass.fromJson(Map<String, String> json) {
    this.name = json["name"];
    this.id = json["id"];
    this.description = json["description"];
    this.registrationLink = json["registrationLink"];
  }
}
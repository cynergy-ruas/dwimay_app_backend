class User {

  /// private constructor.
  User._();

  /// The claims of the user
  Map<String, dynamic> claims;

  /// The registered events of the user
  List<String> regEventIDs;

  /// Boolean which specifies whether the user is logged in or not
  bool isLoggedIn = false;

  /// The instance of this class
  static User _instance;

  /// Setter for [claims]
  void setClaims(Map<String, dynamic> claims) {
    this.claims = claims;
  }

  /// Returns the email id of the user.
  /// The claims need to be set before this function
  /// is called.
  String getEmailID() {
    return claims["email"];
  }

  /// Returns the event id assigned to this user.
  /// Will be null if the user is a level 0 user.
  String getEventId() => 
    claims["eventID"];

  /// Gets the clearance level of the user.
  /// The claims need to be set before this function
  /// is called.
  int getClearanceLevel() {
    if (claims["clearance"] == null)
      return 0;

    return claims["clearance"];
  }

  /// Gets an instance of this class. Only one
  /// instance of this class should exist.
  static User get instance {
    if (_instance == null) {
      _instance = User._();
    }
    return _instance;
  }
}
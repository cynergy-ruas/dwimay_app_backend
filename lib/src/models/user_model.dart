class User {

  /// private constructor.
  User._();

  Map<String, dynamic> claims;
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
import 'package:cloud_functions/cloud_functions.dart' as firebase_functions;
import 'package:dwimay_backend/src/models/announcement_model.dart';

import 'package:meta/meta.dart';

class CloudFunctions {

  /// Instance of this class
  static CloudFunctions _instance;

  CloudFunctions._();

  /// Updates the clearance level of a user using firebases's cloud functions.
  Future<dynamic> updateClearanceForUser({@required String email, @required int clearance}) async {
    // getting reference to cloud function
    final firebase_functions.HttpsCallable updateClearance = firebase_functions.CloudFunctions.instance.getHttpsCallable(
      functionName: "updateClearance"
    );

    // calling the function with the data
    firebase_functions.HttpsCallableResult response = await updateClearance.call({
      "email": email,
      "clearance": clearance,
    });

    // returning response
    return response.data;
  }

  /// Publishes a notification
  Future<dynamic> publishNotification(
    {@required String topic, @required Announcement announcement}) async {
    // getting reference to cloud function
    final firebase_functions.HttpsCallable publishNotification = firebase_functions.CloudFunctions.instance.getHttpsCallable(
      functionName: "publishNotification"
    );

    // calling the function with the data
    firebase_functions.HttpsCallableResult response = await publishNotification.call({
      "topic": topic,
      "title": announcement.title,
      "body": announcement.body,
      "data": announcement.data
    });

    return response.data;
  }

  static CloudFunctions get instance {
    if (_instance == null) 
      _instance = CloudFunctions._();
    return instance;
  }
}
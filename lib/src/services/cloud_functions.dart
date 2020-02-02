import 'package:cloud_functions/cloud_functions.dart' as f;
import 'package:dwimay_backend/src/models/announcement_model.dart';

import 'package:meta/meta.dart';

class CloudFunctions {

  /// Instance of this class
  static CloudFunctions _instance;

  CloudFunctions._();

  /// Updates the clearance level of a user using firebases's cloud functions.
  Future<dynamic> updateClearanceForUser({@required String email, @required int clearance}) async {
    // getting reference to cloud function
    final f.HttpsCallable updateClearance = f.CloudFunctions.instance.getHttpsCallable(
      functionName: "updateClearance"
    );

    // calling the function with the data
    f.HttpsCallableResult response = await updateClearance.call({
      "email": email,
      "clearance": clearance,
    });

    // returning response
    return response.data;
  }

  /// Publishes a notification
  Future<dynamic> publishNotification(
    {@required String eventId, @required String departmentid, @required Announcement announcement}) async {
    // getting reference to cloud function
    final f.HttpsCallable publishNotification = f.CloudFunctions.instance.getHttpsCallable(
      functionName: "publishNotification"
    );

    // calling the function with the data
    f.HttpsCallableResult response = await publishNotification.call({
      "eventid": eventId,
      "department": departmentid,
      "title": announcement.title,
      "body": announcement.body,
      "data": announcement.data
    });

    return response.data;
  }

  /// Assigns an event to a user
  Future<dynamic> assignEventsToUser({@required String email, @required String eventID}) async {
    // getting reference to cloud function
    final f.HttpsCallable assignEventsToUser = f.CloudFunctions.instance.getHttpsCallable(
      functionName: "assignEventsToUser"
    );

    // calling the function with the data
    f.HttpsCallableResult response = await assignEventsToUser.call({
      "email": email,
      "eventID": eventID
    });

    return response.data;
  }

  /// Sets the FCM token for a user
  Future<void> setFCMToken({@required String email, @required String token}) async {
    // getting reference to cloud function
    final f.HttpsCallable setFCMToken = f.CloudFunctions.instance.getHttpsCallable(functionName: "setFCMToken");

    // calling the function with the data
    return await setFCMToken.call({
      "emailid": email,
      "token": token
    });
  }

  static CloudFunctions get instance {
    if (_instance == null) 
      _instance = CloudFunctions._();
    return _instance;
  }
}
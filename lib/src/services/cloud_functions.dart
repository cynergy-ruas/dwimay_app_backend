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

  /// Registers a user
  Future<bool> registerUser({@required String email, @required String password}) async {
    // getting reference to cloud function
    final f.HttpsCallable registerUser = f.CloudFunctions.instance.getHttpsCallable(
      functionName: "registerUser"
    );

    // calling the function with the data and getting the response
    try {
      await registerUser.call({
        "emailid": email,
        "password": password,
      });

      // returning true, indicating that the registration was successful.
      return true;
    }
    on f.CloudFunctionsException catch (e) {
      print(e);
      return false;
    }
    catch(e) {
      print(e);
      return false;
    }
  }

  static CloudFunctions get instance {
    if (_instance == null) 
      _instance = CloudFunctions._();
    return _instance;
  }
}
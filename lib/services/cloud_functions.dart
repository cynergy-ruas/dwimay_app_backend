import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';

/// Updates the clearance level of a user using firebases's cloud functions.
Future<dynamic> updateClearanceForUser({@required String email, @required int clearance}) async {
  // getting reference to cloud function
  final HttpsCallable updateClearance = CloudFunctions.instance.getHttpsCallable(
    functionName: "updateClearance"
  );

  // calling the function with the data
  HttpsCallableResult response = await updateClearance.call({
    "email": email,
    "clearance": clearance,
  });

  // returning response
  return response.data;
}

/// Publishes a notification
Future<dynamic> publishNotification(
  {@required String topic, @required String title, @required String body, @required Map<String, dynamic> data}) async {
  // getting reference to cloud function
  final HttpsCallable publishNotification = CloudFunctions.instance.getHttpsCallable(
    functionName: "publishNotification"
  );

  // calling the function with the data
  HttpsCallableResult response = await publishNotification.call({
    "topic": topic,
    "title": title,
    "body": body,
    "data": data
  });

  return response.data;
}
import 'package:dwimay_backend/src/models/attendee_info_model.dart';
import 'package:dwimay_backend/src/models/pass_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';

import 'database.dart';

/// Singleton class that handles communication with townscript API
class TownscriptAPI {

  /// The instance of this class
  static TownscriptAPI _instance;

  /// The API token
  static String _token;

  /// Bool that defines whether this class was initialized using [init] method
  static bool isInit = false;

  TownscriptAPI._();

  /// gets all the registered users of an event
  Future<List<AttendeeInfo>> getRegisteredUsers({@required String eventCode, bool includePasses = false}) async {

    // initializing the list of [AttendeeInfo]
    List<AttendeeInfo> attendeeInfo = List<AttendeeInfo>();

    // get request headers
    Map<String, String> headers = {
      "Authorization": _token,
    };

    // getting the attendee info of the event
    http.Response res = await http.get(
      "https://www.townscript.com/api/registration/getRegisteredUsers?eventCode=$eventCode",
      headers: headers
    );
    
    if (json.decode(res.body)["result"] != "Error")
      // extracting info and adding as [AttendeeInfo] objects
      _extractAndAdd(res, attendeeInfo);

    if (includePasses) {
      // getting the passes from firestore
      List<Pass> passes = await (await Database.instance).getPasses();

      // getting the attendee data for each of the passes
      List<http.Response> responses = await Future.wait<http.Response>(
        passes.map(
          (pass) => http.get(
            "https://www.townscript.com/api/registration/getRegisteredUsers?eventCode=${pass.id}",
            headers: headers
          )
        ).toList()
      );

      // populating the [attendeeInfo] list
      for (http.Response res in responses)
        if (json.decode(json.decode(res.body)["data"]).length != 0)
          // extracting info and adding as [AttendeeInfo] objects
          _extractAndAdd(res, attendeeInfo);
    }

    return attendeeInfo;
  }

  /// Extracts the attendee info from [res] and adds it to the [list]
  void _extractAndAdd(http.Response res, List<AttendeeInfo> list) {
    try {    
      // when there is more than one registration, townscript sends a list
      // hence, converting each item in list into [AttendeeInfo]
      list.addAll(List<AttendeeInfo>.from(json.decode(json.decode(res.body)["data"]).map((entry) => AttendeeInfo.fromJson(entry))));
    }
    catch (e) {
      // if there is one registration, townscript sends a dictionary. hence,
      // converting the dictionary to [AttendeeInfo] and adding it in a list
      list.add(AttendeeInfo.fromJson(json.decode(json.decode(res.body)["data"])));
    }
  }

  /// Used to set the token
  static void init(String token) { 
    _token = token;
    isInit = true;
  }

  /// gets the instance of this class
  static TownscriptAPI get instance {
    if (_instance == null) {
      assert(isInit == true, "API should be initialized first by calling init() method");
      _instance = TownscriptAPI._();
    }

    return _instance;
  }
}
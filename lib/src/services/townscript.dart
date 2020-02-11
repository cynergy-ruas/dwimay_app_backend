import 'package:dwimay_backend/src/models/attendee_info_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:convert';

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
  Future<List<AttendeeInfo>> getRegisteredUsers({@required String eventCode}) async {
    http.Response res = await http.get(
      "https://www.townscript.com/api/registration/getRegisteredUsers?eventCode=$eventCode",
      headers: {
        "Authorization": _token
      }
    );

    try {    
      // when there is more than one registration, townscript sends a list
      // hence, converting each item in list into [AttendeeInfo]
      return List<AttendeeInfo>.from(json.decode(json.decode(res.body)["data"]).map((entry) => AttendeeInfo.fromJson(entry)));
    }
    catch (e) {
      // if there is one registration, townscript sends a dictionary. hence,
      // converting the dictionary to [AttendeeInfo] and adding it in a list
      return <AttendeeInfo>[AttendeeInfo.fromJson(json.decode(json.decode(res.body)["data"]))];
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
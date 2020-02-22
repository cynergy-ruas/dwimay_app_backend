import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// represents an announcement
class Announcement {
  
  /// The title of the announcement
  String title;

  /// The description/body of the annoucement
  String body;

  /// Any additional data
  Map<String, dynamic> data;

  Announcement({@required this.title, @required this.body, @required this.data});

  Announcement.fromMap({@required Map<String, dynamic> map}) {
    if (Platform.isIOS) {
      if (map["data"] != null) {
        this.title = map["data"]["title"].toString();
        this.body = map["data"]["body"].toString();
        this.data = Map<String, dynamic>.from(map["data"])..removeWhere((String key, dynamic value) => key == "title" || key == "body");
      }
      else {
        this.title = map["notification"]["title"].toString();
        this.body = map["notification"]["body"].toString();
        this.data = map..removeWhere((String key, dynamic value) => key == "notification" || key == "title" || key == "body");
      }
    }
    else {
      // notifications key is null when a notification is received when the app
      // is in background or closed on android
      if (map['notifications'] == null) {
        this.title = map["data"]["title"];
        this.body = map["data"]["body"];
        this.data = Map<String, dynamic>.from(map["data"])..removeWhere((String key, dynamic value) => key == "title" || key == "body");
      }
      else {
        this.title = map['notification']['title'].toString();
        this.body = map['notification']['body'].toString();
        this.data = Map<String, dynamic>.from(map['data']);
      }
    }
  }

  Announcement.fromStorage({@required Map<String, dynamic> map}) {
    this.title = map["notification"]["title"].toString();
    this.body = map["notification"]["body"].toString();
    this.data = Map<String, dynamic>.from(map["data"]);
  }

  Announcement.fromRaw({@required this.title, @required this.body, this.data});

  /// converts the [Announcement] to a [Map]
  Map<String, dynamic> toMap() => <String, dynamic> {
    "notification": {
      "title": this.title,
      "body": this.body,
    },
    "data": this.data,
  };

  String toString() =>
    "Announcement[title: ${this.title}, body: ${this.body}]";
}

/// Contains all the announcements
class AnnouncementPool {
  
  /// The announcements
  ValueNotifier<List<Announcement>> _announcements;

  /// instance of this class
  static AnnouncementPool _instance;

  AnnouncementPool._() :
    _announcements =  ValueNotifier<List<Announcement>>(List<Announcement>());
  
  /// Adds an announcement to the pool
  void add({@required Announcement announcement}) => 
  // creating a new list and assigning it to [_announcements.value] so 
  // that the [ValueNotifier] calls [notifyListeners]. 
  _announcements.value = List.from(_announcements.value)..add(announcement);

  /// Adds a list of announcements to the pool
  void addAll({@required List<Announcement> announcements}) => 
    _announcements.value = List.from(_announcements.value)..addAll(announcements);

  /// Removes an item from the [AnnouncementPool]
  void remove({@required int index}) =>
    _announcements.value = List.from(_announcements.value)..removeAt(index);

  /// Clears the annoucements in the pool
  void clear() => _announcements.value = List<Announcement>();
  
  /// The raw form of the announcements
  List<Map<String, dynamic>> get raws => _announcements.value.map((a) => a.toMap()).toList();

  /// The annoucements
  List<Announcement> get announcements => _announcements.value;

  /// The notifier
  ValueNotifier<List<Announcement>> get listenable => _announcements;

  /// returns the instance of this class
  static AnnouncementPool get instance {
    if (_instance == null)
      _instance = AnnouncementPool._();

    return _instance;
  }
}
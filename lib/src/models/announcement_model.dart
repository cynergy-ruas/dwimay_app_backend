import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// represents an announcement
class Announcement extends Equatable{

  /// The id of the announcement
  String id;
  
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
        this.id = this.data["id"];
      }
      else {
        this.title = map["notification"]["title"].toString();
        this.body = map["notification"]["body"].toString();
        this.data = map..removeWhere((String key, dynamic value) => key == "notification" || key == "title" || key == "body");
        this.id = this.data["id"];
      }
    }
    else {
      // notifications key is null when a notification is received when the app
      // is in background or closed on android
      if (map['notifications'] == null) {
        this.title = map["data"]["title"];
        this.body = map["data"]["body"];
        this.data = Map<String, dynamic>.from(map["data"])..removeWhere((String key, dynamic value) => key == "title" || key == "body");
        this.id = this.data["id"];      
      }
      else {
        this.title = map['notification']['title'].toString();
        this.body = map['notification']['body'].toString();
        this.data = Map<String, dynamic>.from(map['data']);
        this.id = this.data["id"];
      }
    }
  }

  Announcement.fromStorage({@required Map<String, dynamic> map}) {
    this.title = map["notification"]["title"].toString();
    this.body = map["notification"]["body"].toString();
    this.data = Map<String, dynamic>.from(map["data"]);
    this.id = map["id"].toString();
  }

  Announcement.fromRaw({@required this.title, @required this.body, this.data});

  /// converts the [Announcement] to a [Map]
  Map<String, dynamic> toMap() => <String, dynamic> {
    "notification": {
      "title": this.title,
      "body": this.body,
    },
    "data": this.data,
    "id": this.id
  };

  String toString() =>
    "Announcement[id: ${this.id}, title: ${this.title}, body: ${this.body}]";

  @override
  List<Object> get props => [this.id];
}

/// Contains all the announcements
class AnnouncementPool {
  
  /// The announcements
  ValueNotifier<Map<String, Announcement>> _announcements;

  /// instance of this class
  static AnnouncementPool _instance;

  AnnouncementPool._() :
    _announcements =  ValueNotifier<Map<String, Announcement>>(Map<String, Announcement>());
  
  /// Adds an announcement to the pool
  void add({@required Announcement announcement}) {
    _announcements.value[announcement.id] = announcement;
    _announcements.value = Map<String, Announcement>.from(_announcements.value);
  }

  /// Adds a list of announcements to the pool
  void addAll({@required List<Announcement> announcements}) {
    Map<String, Announcement> temp = {};
    for (int i = 0; i < announcements.length; i++) {
      temp[announcements[i].id] = announcements[i];
    }

    _announcements.value = Map<String, Announcement>.from(temp);
  }
 

  /// Removes an item from the [AnnouncementPool]
  void remove({@required Announcement announcement}) =>
    _announcements.value = _announcements.value..remove(announcement.id);

  /// Clears the annoucements in the pool
  void clear() => _announcements.value = Map<String, Announcement>();
  
  /// The raw form of the announcements
  List<Map<String, dynamic>> get raws => _announcements.value.values.map((a) => a.toMap()).toList();

  /// The annoucements
  List<Announcement> get announcements => _announcements.value.values.toList();

  /// The notifier
  ValueNotifier<Map<String, Announcement>> get listenable => _announcements;

  /// returns the instance of this class
  static AnnouncementPool get instance {
    if (_instance == null)
      _instance = AnnouncementPool._();

    return _instance;
  }
}
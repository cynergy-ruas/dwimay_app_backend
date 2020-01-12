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
    this.title = map['notification']['title'];
    this.body = map['notification']['body'];
    this.data = Map<String, dynamic>.from(map['data']);
  }

  /// converts the [Announcement] to a [Map]
  Map<String, dynamic> toMap() => <String, dynamic> {
    "notification": {
      "title": this.title,
      "body": this.body,
    },
    "data": this.data,
  };
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
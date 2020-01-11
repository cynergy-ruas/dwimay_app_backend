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
  static List<Announcement> _announcements = List<Announcement>();

  /// Adds an announcement to the pool
  static void add({@required Announcement announcement}) => _announcements.add(announcement);

  /// Adds a list of announcements to the pool
  static void addAll({@required List<Announcement> announcements}) => 
    _announcements.addAll(announcements);

  /// Clears the annoucements in the pool
  static void clear() => _announcements = List<Announcement>();
  
  /// The raw form of the announcements
  static List<Map<String, dynamic>> get raws => _announcements.map((a) => a.toMap()).toList();

  /// The annoucements
  static List<Announcement> get announcements => _announcements;
}
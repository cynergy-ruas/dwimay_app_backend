import 'package:dwimay_backend/src/models/announcement_model.dart';
import 'package:flutter/material.dart';

/// The widget that builds the UI that displays the 
/// [Announcement]s. Widget rebuilds whenever the 
/// [AnnouncementPool] is updated. The [NotificationListener]
/// widget **should** be an ancestor to this widget.
class AnnouncementsBuilder extends StatefulWidget {

  /// The function that builds the widget
  final Widget Function(BuildContext, List<Announcement>) builder; 

  AnnouncementsBuilder({@required this.builder});

  @override
  AnnouncementsBuilderState createState() => AnnouncementsBuilderState();
}

class AnnouncementsBuilderState extends State<AnnouncementsBuilder> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AnnouncementPool.instance.listenable,
      builder: (BuildContext context, Map<String, Announcement> announcements, _) {
        List<Announcement> aList = announcements.values.toList()..sort(
          (Announcement a, Announcement b) => b.id.compareTo(a.id)
        );
        return widget.builder(context, aList);
      }
    );
  }
}

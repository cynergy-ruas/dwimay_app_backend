import 'package:dwimay_backend/managers/manager.dart';
import 'package:dwimay_backend/models/announcement_model.dart';
import 'package:dwimay_backend/services/cloud_functions.dart' as cloud_functions;
import 'package:meta/meta.dart';

class FunctionsManager extends Manager {

  static FunctionsManager _instance;

  FunctionsManager._();

  @override
  Future<void> load() => null;

  Future<dynamic> publishNotification({@required String topic, @required Announcement announcement}) =>
    cloud_functions.publishNotification(
      topic: topic,
      title: announcement.title,
      body: announcement.body,
      data: announcement.data
    );

  static FunctionsManager get instance {
    if (_instance == null)
      _instance = FunctionsManager._();

    return _instance;
  }
}
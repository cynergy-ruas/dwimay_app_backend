import 'package:dwimay_backend/managers/manager.dart';
import 'package:dwimay_backend/models/announcement_model.dart';
import 'package:dwimay_backend/services/cloud_functions.dart' as cloud_functions;
import 'package:meta/meta.dart';

/// Handles the cloud functions.
class FunctionsManager extends Manager {

  /// Instance of this class
  static FunctionsManager _instance;

  FunctionsManager._();

  @override
  Future<void> load() => null;

  /// Publishes a notification
  Future<dynamic> publishNotification({@required String topic, @required Announcement announcement}) =>
    cloud_functions.publishNotification(
      topic: topic,
      title: announcement.title,
      body: announcement.body,
      data: announcement.data
    );

  /// Gets the instance of this class
  static FunctionsManager get instance {
    if (_instance == null)
      _instance = FunctionsManager._();

    return _instance;
  }
}
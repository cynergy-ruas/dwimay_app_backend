import 'package:dwimay_backend/managers/manager.dart';
import 'package:dwimay_backend/models/announcement_model.dart';
import 'package:dwimay_backend/services/file_provider.dart';

/// Manages loading and updating the [AnnouncementPool] from 
/// local storage.
class AnnouncementManager extends Manager {

  /// Loads the announcements from local storage.
  @override
  Future<void> load() async {
    // getting instance of [FileProvider]
    FileProvider _instance = await FileProvider.instance;

    // clearing the pool
    AnnouncementPool.instance.clear();

    // populating the pool with [Announcement] objects by loading
    // the data from local storage and converting each of the loaded
    // data into an [Announcement] object.
    AnnouncementPool.instance.addAll(
      announcements: (await _instance.loadAnnouncements()).map<Announcement>(
        (a) => Announcement.fromMap(map: a)
      ).toList()
    );
  }

  /// Updates the [AnnouncementPool] and the local storage.
  /// called from a [Bloc].
  @override
  Future<void> update({dynamic payload}) {
    // creating an [Announcement] object
    Announcement a = Announcement.fromMap(map: payload);

    // adding [Announcement] object to [AnnouncementPool]
    AnnouncementPool.instance.add(announcement: a);

    // updating local storage
    return FileProvider.instance.then((instance) => 
      instance.dumpAnnouncments(
        data: AnnouncementPool.instance.raws
      )
    );
  }

  /// Clears [AnnouncementPool] and deletes announcements from
  /// local storage
  Future<void> delete() {
    // clearing [AnnouncementPool]
    AnnouncementPool.instance.clear();

    // deleting from local storage
    return FileProvider.instance.then((instance) => instance.deleteAnnouncements());
  }
}
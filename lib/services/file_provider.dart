import 'dart:io';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

class FileProvider {
  static FileProvider _instance;
  static Directory _appDirectory;

  FileProvider._();

  /// dumps announcements to local storage
  void dumpAnnouncments({@required List<Map<String, dynamic>> data}) {
    // encoding [payload] to json string
    String jsonString = json.encode(data);

    // storing payload in file
    File("${_appDirectory.path}/announcements.json").writeAsString(jsonString, flush: true);
  }

  /// loads announcements from local storage
  Future<List<Map<String, dynamic>>> loadAnnouncements() async {
    // getting path to file
    File path = File("${_appDirectory.path}/announcements.json");

    if (await path.exists())
      // decoding json string in file and accessing the 'messages' key
      return json.decode(await path.readAsString()).cast<Map<String, dynamic>>();

    // returning empty list if path does not exist.
    return List<Map<String, dynamic>>();
  }

  /// deletes the announcements 
  void deleteAnnouncements() async {
    // getting path to file
    File path = File("${_appDirectory.path}/announcements.json");

    if (await path.exists())
      path.delete();
  }

  /// gets the instance of this class.
  static Future<FileProvider> get instance async {
    if (_instance == null) {
      _instance = FileProvider._();
      _appDirectory = await getApplicationDocumentsDirectory();
    }
    
    return _instance;
  }

}
import 'package:dwimay_backend/src/models/events_model.dart';
import 'package:dwimay_backend/src/models/pass_model.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static Database _instance;
  static Firestore _firestore;

  /// Private constructor
  Database._();

  /// Gets all the events 
  Future<List<Map<String, dynamic>>> getAllEvents() async {
    List<Map<String, dynamic>> data = [];
    // getting a reference to the collection in firestore
    CollectionReference coll = _firestore.collection("events");

    // getting all documents in the reference
    QuerySnapshot snapshot = await coll.getDocuments();

    // adding the contents in each document obtained to [data]
    snapshot.documents.forEach((doc) {
      Map<dynamic, dynamic> docData = doc.data;
      docData["docRef"] = doc.documentID;
      data.add(docData);
    });

    //returning data
    return data;
  }

  /// Gets the list of registered events event IDs for a user
  Future<List<String>> getRegisteredEventsForUser({@required String email}) async =>
    List<String>.from(((await _firestore.collection("users").document(email).get()).data ?? const {})["regEvents"] ?? []);
  
  /// Gets the passes the user paid for.
  Future<Map<String, dynamic>> getPassesForUser({@required String email}) async =>
    Map<String, dynamic>.from(((await _firestore.collection("users").document(email).get()).data ?? const {})["passes"] ?? {});

  /// Deletes the [event] from firestore.
  Future<void> deleteEvent({@required Event event}) async {
    await _firestore.collection("events").document(event.documentID).delete();
  }

  /// Updates the event in firestore with the information in [event].
  Future<void> updateEvent({@required Event event}) async {
    // creating a reference to the document containing the event data
    DocumentReference doc = _firestore.collection("EventsList").document(event.documentID);

    // updating data
    await doc.updateData({
      "datetimes": event.datetimes.map((date) => Timestamp.fromDate(date)).toList(),
      "department": event.department,
      "description": event.description,
      "name": event.name,
      "speaker": event.speaker,
      "type": event.type,
      "venue": event.venue,
      "registrationLink": event.registrationLink   
    });
  }

  /// Checks if the [document] in the [collection] exists or not
  Future<bool> exists({@required String document, @required String collection}) async => 
    (await _firestore.collection(collection).document(document).get()).exists;

  /// Gets all the passes from firestore
  Future<List<Pass>> getPasses() async =>
    (await _firestore.collection("passes").getDocuments()).documents
    .where(
      (DocumentSnapshot doc) => doc.documentID != "template"
    )
    .map(
      (DocumentSnapshot doc) =>
        Pass.fromJson(Map<String, String>.from(doc.data))
    )
    .toList();

  /// Gets an instance of this class. Only one instance of this class should 
  /// exists. Also performs some initialization.
  static Future<Database> get instance async {
    // if no instance was created, run body
    if (_instance == null) {
      // apply settings
      Firestore().settings(timestampsInSnapshotsEnabled: true);

      // create required instances
      _instance = Database._();
      _firestore = Firestore.instance;
    }

    // returning instance
    return _instance;
  }
}
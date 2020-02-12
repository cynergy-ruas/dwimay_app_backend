import 'package:dwimay_backend/src/models/registered_event.dart';
import 'package:dwimay_backend/src/models/user_model.dart';
import 'package:dwimay_backend/src/services/database.dart';

import 'states.dart';
import 'events.dart';
import 'package:bloc/bloc.dart';

class RegisteredEventsBloc extends Bloc<RegEventsEvent, RegEventsState> {
  @override
  RegEventsState get initialState => RegEventsInit();

  @override
  Stream<RegEventsState> mapEventToState(RegEventsEvent event) async* {
    if (event is BeginRegEventsLoad) {
      yield RegEventsLoading();

      try {
        
        List<RegisteredEvent> regEvents = [];

        // loading the data from firestore
        User.instance.regEventIDs = await (await Database.instance).getRegisteredEventsForUser(email: User.instance.getEmailID());

        // adding the [regEventIDs] to [regEvents] as [RegisteredEvent] objects
        regEvents.addAll(
          User.instance.regEventIDs.map(
            (id) => RegisteredEvent(id: id)
          )
        );
        
        // loading pass information from firestore
        (await (await Database.instance).getPassesForUser(email: User.instance.getEmailID())).forEach(
          (String id, dynamic data) {
            Map<String, dynamic> info = Map<String, dynamic>.from(data);
            regEvents.add(RegisteredEvent(id: id, eventNames: List<String>.from(info["events"]), isPass: true, registrationId: info["id"].toString()));
          }
        );
        
        
        // yielding events loaded state
        yield RegEventsLoaded(regEvents: regEvents);
      }
      catch (e) {
        yield RegEventsError(error: e);
      }
    }
  }

}

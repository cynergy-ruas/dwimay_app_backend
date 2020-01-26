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
        // loading the data from firestore
        User.instance.regEventIDs = await (await Database.instance).getRegisteredEventsForUser(email: User.instance.getEmailID());

        // yeilding events loaded state
        yield RegEventsLoaded();
      }
      catch (e) {
        yield RegEventsError(error: e);
      }
    }
  }

}

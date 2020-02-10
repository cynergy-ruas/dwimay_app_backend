import 'events.dart';
import 'states.dart';
import 'package:bloc/bloc.dart';
import 'package:dwimay_backend/src/services/townscript.dart';

/// Bloc that handles the loading of user data from the townscript
/// api
class UserInfoLoadBloc extends Bloc<UserDataLoadEvent, DataLoadState>{
  @override
  DataLoadState get initialState => DataLoadUnintialized();

  @override
  Stream<DataLoadState> mapEventToState(UserDataLoadEvent event) async *{
    if (event is BeginUserDataLoad) {
      // yielding data load ongoing
      yield DataLoadOnGoing();

      try {
        // loading user data from townscript
        List<String> data = await TownscriptAPI.instance.getRegisteredUsers(eventCode: event.eventCode);


        // yielding load complete state
        yield DataLoadComplete(data: data);
      }

      catch (e) {
        // yielding error state
        yield DataLoadError(exception: e);
      }
    }
  }

}
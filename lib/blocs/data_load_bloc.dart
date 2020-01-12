import 'package:bloc/bloc.dart';
import 'package:dwimay_backend/managers/manager.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// Defining the events

/// The base class for data load events
abstract class DataLoadEvent extends Equatable {
  DataLoadEvent([List props = const []]) : super(props);
}

/// The event emitted when data loading is initiated
class BeginDataLoad extends DataLoadEvent {
  @override
  String toString() => "BeginDataLoad";
}

/// The event emitted when data is to be updated
class UpdateData extends DataLoadEvent {

  /// Additional information
  final dynamic payload;

  UpdateData({this.payload});

  @override
  String toString() => "UpdateData[payload: $payload]";
}

// Defining the states

/// The base class for data load states
abstract class DataLoadState extends Equatable {
  DataLoadState();
}

/// The state when the data loading is uninitialized
class DataLoadUnintialized extends DataLoadState {
  DataLoadUnintialized() : super();
  String toString() => "DataLoadUninitialized";
}

/// The state when data loading is ongoing
class DataLoadOnGoing extends DataLoadState {
  DataLoadOnGoing() : super();
    String toString() => "DataLoadOnGoing";
}

/// The state when there is an error loading data
class DataLoadError extends DataLoadState {
  final exception;
  DataLoadError({@required this.exception}) : super();

  String toString() => "DataLoadError[error: ${exception.toString()}]";
}

/// The state when data loading is complete
class DataLoadComplete extends DataLoadState {
  DataLoadComplete() : super();
  String toString() => "DataLoadComplete";
}

// Defining the Bloc. Logic goes here

class DataLoadBloc extends Bloc<DataLoadEvent, DataLoadState>{
  
  final Manager manager;
  
  DataLoadBloc({@required this.manager});

  @override
  DataLoadState get initialState => DataLoadUnintialized();

  /// Maps [DataLoadEvent]s to [DataLoadState]s. Yields a [DataLoadState] in 
  /// response to the [DataLoadEvent].
  @override
  Stream<DataLoadState> mapEventToState(DataLoadEvent event) async* {
    if (event is BeginDataLoad) {
      // yielding data load on going
      yield DataLoadOnGoing();

      // loading data
      try {
        await manager.load();
        // yielding data load complete state
        yield DataLoadComplete();
      } 
      catch (e) {
        yield DataLoadError(exception: e);
        yield initialState;
      }
    }

    if (event is UpdateData) {
      // yielding data load on going
      yield DataLoadOnGoing();

      try {
        await manager.update(payload: event.payload);
        // yielding data load complete state
        yield DataLoadComplete();
      }
      catch (e) {
        yield DataLoadError(exception: e);
        yield initialState;
      }
    }
  }
  
}

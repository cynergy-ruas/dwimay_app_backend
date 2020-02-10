import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

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

  final List<String> data;

  DataLoadComplete({@required this.data}) : super();
  String toString() => "DataLoadComplete";
}
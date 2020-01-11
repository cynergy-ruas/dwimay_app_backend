/// Base class for all managers
abstract class Manager {
  
  /// Loads the data to a pool. Used in a [Bloc]
  Future<void> load();

  /// Updates data in the pool. Used in a [Bloc]
  Future<void> update({dynamic payload}) {
    return null;
  }
}
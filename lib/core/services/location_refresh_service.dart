import 'dart:async';

/// Service that manages automatic refresh when location changes.
/// Cubits register themselves with a refresh callback.
/// When location changes, all registered callbacks are triggered.
class LocationRefreshService {
  LocationRefreshService._();
  static final LocationRefreshService _instance = LocationRefreshService._();
  static LocationRefreshService get instance => _instance;

  // Stream controller for location change events
  final _locationChangeController = StreamController<LocationChangeEvent>.broadcast();

  /// Stream that emits when location changes
  Stream<LocationChangeEvent> get onLocationChange => _locationChangeController.stream;

  // Map of registered refresh callbacks (key = unique id, value = callback)
  final Map<String, void Function(LocationChangeEvent)> _refreshCallbacks = {};

  /// Register a cubit/service to be refreshed on location change
  /// Returns a subscription that should be cancelled in dispose()
  StreamSubscription<LocationChangeEvent> register({
    required String id,
    required void Function(LocationChangeEvent event) onRefresh,
  }) {
    _refreshCallbacks[id] = onRefresh;
    
    // Return subscription for the stream
    return _locationChangeController.stream.listen((event) {
      // Callback will be triggered when location changes
      if (_refreshCallbacks.containsKey(id)) {
        _refreshCallbacks[id]!(event);
      }
    });
  }

  /// Unregister a cubit/service
  void unregister(String id) {
    _refreshCallbacks.remove(id);
  }

  /// Trigger location change - call this from LocationCubit
  void notifyLocationChanged({
    required int? countryId,
    required int? cityId,
    String? countryName,
    String? cityName,
  }) {
    _locationChangeController.add(LocationChangeEvent(
      countryId: countryId,
      cityId: cityId,
      countryName: countryName,
      cityName: cityName,
    ));
  }

  /// Clear all registered callbacks (useful for testing)
  void clearAll() {
    _refreshCallbacks.clear();
  }

  /// Dispose the service
  void dispose() {
    _locationChangeController.close();
    _refreshCallbacks.clear();
  }
}

/// Event data for location changes
class LocationChangeEvent {
  final int? countryId;
  final int? cityId;
  final String? countryName;
  final String? cityName;

  LocationChangeEvent({
    this.countryId,
    this.cityId,
    this.countryName,
    this.cityName,
  });
}

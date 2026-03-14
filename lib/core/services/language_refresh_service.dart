import 'dart:async';

/// Service that manages automatic refresh when language changes.
/// Cubits register themselves with a refresh callback.
/// When language changes, all registered callbacks are triggered.
class LanguageRefreshService {
  LanguageRefreshService._();
  static final LanguageRefreshService _instance = LanguageRefreshService._();
  static LanguageRefreshService get instance => _instance;

  // Stream controller for language change events
  final _languageChangeController = StreamController<String>.broadcast();

  /// Stream that emits when language changes
  Stream<String> get onLanguageChange => _languageChangeController.stream;

  // Map of registered refresh callbacks (key = unique id, value = callback)
  final Map<String, VoidCallback> _refreshCallbacks = {};

  /// Register a cubit/service to be refreshed on language change
  /// Returns a subscription that should be cancelled in dispose()
  StreamSubscription<String> register({
    required String id,
    required VoidCallback onRefresh,
  }) {
    _refreshCallbacks[id] = onRefresh;
    
    // Return subscription for the stream
    return _languageChangeController.stream.listen((_) {
      // Callback will be triggered when language changes
      if (_refreshCallbacks.containsKey(id)) {
        _refreshCallbacks[id]!();
      }
    });
  }

  /// Unregister a cubit/service
  void unregister(String id) {
    _refreshCallbacks.remove(id);
  }

  /// Trigger language change - call this from LanguageCubit
  void notifyLanguageChanged(String newLanguageCode) {
    _languageChangeController.add(newLanguageCode);
  }

  /// Clear all registered callbacks (useful for testing)
  void clearAll() {
    _refreshCallbacks.clear();
  }

  /// Dispose the service
  void dispose() {
    _languageChangeController.close();
    _refreshCallbacks.clear();
  }
}

typedef VoidCallback = void Function();

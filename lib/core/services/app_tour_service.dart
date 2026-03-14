import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage app tour/showcase state
class AppTourService {
  static const String _hasCompletedTourKey = 'has_completed_app_tour';
  static const String _hasCompletedSearchTourKey = 'has_completed_search_tour';
  static const String _currentTourStepKey = 'current_tour_step';
  
  final SharedPreferences _prefs;
  
  AppTourService(this._prefs);
  
  /// Check if user has completed the app tour
  bool hasCompletedTour() {
    return _prefs.getBool(_hasCompletedTourKey) ?? false;
  }
  
  /// Mark tour as completed
  Future<void> completeTour() async {
    await _prefs.setBool(_hasCompletedTourKey, true);
    await _prefs.remove(_currentTourStepKey);
  }
  
  /// Skip tour
  Future<void> skipTour() async {
    await completeTour();
  }
  
  /// Check if user has completed the search tour
  bool hasCompletedSearchTour() {
    return _prefs.getBool(_hasCompletedSearchTourKey) ?? false;
  }
  
  /// Mark search tour as completed
  Future<void> completeSearchTour() async {
    await _prefs.setBool(_hasCompletedSearchTourKey, true);
  }
  
  /// Skip search tour
  Future<void> skipSearchTour() async {
    await completeSearchTour();
  }
  
  /// Get current tour step (for resuming)
  int getCurrentStep() {
    return _prefs.getInt(_currentTourStepKey) ?? 0;
  }
  
  /// Save current step
  Future<void> saveCurrentStep(int step) async {
    await _prefs.setInt(_currentTourStepKey, step);
  }
  
  /// Reset tour (for testing)
  Future<void> resetTour() async {
    await _prefs.remove(_hasCompletedTourKey);
    await _prefs.remove(_hasCompletedSearchTourKey);
    await _prefs.remove(_currentTourStepKey);
  }
  
  /// Reset search tour only (for testing)
  Future<void> resetSearchTour() async {
    await _prefs.remove(_hasCompletedSearchTourKey);
  }
}

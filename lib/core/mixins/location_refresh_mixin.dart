import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/location_refresh_service.dart';

/// Mixin that provides automatic refresh when location changes.
/// 
/// Usage:
/// ```dart
/// class MyCubit extends Cubit<MyState> with LocationRefreshMixin {
///   MyCubit() : super(MyInitialState()) {
///     initLocationRefresh('my_cubit_id');
///   }
///   
///   @override
///   void onLocationRefresh(LocationChangeEvent event) {
///     // Reload your data here with new location
///     loadData(countryId: event.countryId, cityId: event.cityId);
///   }
///   
///   @override
///   Future<void> close() {
///     disposeLocationRefresh();
///     return super.close();
///   }
/// }
/// ```
mixin LocationRefreshMixin<T> on BlocBase<T> {
  StreamSubscription<LocationChangeEvent>? _locationSubscription;
  String? _locationRefreshId;

  /// Initialize location refresh listener
  /// Call this in your cubit constructor
  void initLocationRefresh(String id) {
    _locationRefreshId = id;
    _locationSubscription = LocationRefreshService.instance.register(
      id: id,
      onRefresh: (event) {
        if (!isClosed) {
          onLocationRefresh(event);
        }
      },
    );
  }

  /// Override this method to handle location refresh
  /// This will be called automatically when location changes
  void onLocationRefresh(LocationChangeEvent event);

  /// Dispose the location refresh listener
  /// Call this in your cubit's close() method
  void disposeLocationRefresh() {
    _locationSubscription?.cancel();
    if (_locationRefreshId != null) {
      LocationRefreshService.instance.unregister(_locationRefreshId!);
    }
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/language_refresh_service.dart';

/// Mixin that provides automatic refresh when language changes.
/// 
/// Usage:
/// ```dart
/// class MyCubit extends Cubit<MyState> with LanguageRefreshMixin {
///   MyCubit() : super(MyInitialState()) {
///     initLanguageRefresh('my_cubit_id');
///   }
///   
///   @override
///   void onLanguageRefresh() {
///     // Reload your data here
///     loadData();
///   }
///   
///   @override
///   Future<void> close() {
///     disposeLanguageRefresh();
///     return super.close();
///   }
/// }
/// ```
mixin LanguageRefreshMixin<T> on BlocBase<T> {
  StreamSubscription<String>? _languageSubscription;
  String? _refreshId;

  /// Initialize language refresh listener
  /// Call this in your cubit constructor
  void initLanguageRefresh(String id) {
    _refreshId = id;
    _languageSubscription = LanguageRefreshService.instance.register(
      id: id,
      onRefresh: () {
        if (!isClosed) {
          onLanguageRefresh();
        }
      },
    );
  }

  /// Override this method to handle language refresh
  /// This will be called automatically when language changes
  void onLanguageRefresh();

  /// Dispose the language refresh listener
  /// Call this in your cubit's close() method
  void disposeLanguageRefresh() {
    _languageSubscription?.cancel();
    if (_refreshId != null) {
      LanguageRefreshService.instance.unregister(_refreshId!);
    }
  }
}

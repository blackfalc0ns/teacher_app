import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../errors/dio_exception_handler.dart';
import 'api_endpoints.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/auth_interceptor.dart';
import 'app_state_service.dart';

class DioClient {
  late Dio _dio;
  late final AppStateService _appStateService;
  CacheStore? _cacheStore;
  CacheOptions? _cacheOptions;

  // Base URL - يمكن تغييرها حسب البيئة
  static String get _baseUrl => ApiEndpoints.baseUrl;

  DioClient._internal(this._appStateService) {
    _dio = Dio();
    _setupDio();
  }

  static DioClient? _cachedInstance;

  static Future<void> initialize(AppStateService appStateService) async {
    _cachedInstance = DioClient._internal(appStateService);
    await _cachedInstance!._initializeCache();
  }

  static DioClient get instance {
    if (_cachedInstance == null) {
      throw Exception(
        'DioClient not initialized. Call DioClient.initialize() first.',
      );
    }
    return _cachedInstance!;
  }

  Dio get dio => _dio;
  CacheOptions? get cacheOptions => _cacheOptions;

  Future<void> _initializeCache() async {
    if (kIsWeb) {
      // Use memory cache for web
      _cacheStore = MemCacheStore();
    } else {
      // Use Hive for persistent storage on mobile/desktop
      final dir = await getApplicationDocumentsDirectory();
      _cacheStore = HiveCacheStore('${dir.path}/dio_cache');
    }

    _cacheOptions = CacheOptions(
      store: _cacheStore!,
      // Default policy: try cache first, then network
      policy: CachePolicy.request,
      // Cache duration: 30 minutes for general API responses
      maxStale: const Duration(minutes: 30),
      // Cache priority
      priority: CachePriority.normal,
      // Use cache on network errors (offline support)
      hitCacheOnErrorExcept: [401, 403, 404],
      // Key builder - includes query params
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Allow POST requests to be cached (disabled by default)
      allowPostMethod: false,
    );

    // Add cache interceptor
    _dio.interceptors.insert(0, DioCacheInterceptor(options: _cacheOptions!));
  }

  void _setupDio() {
    // Optimized base options
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      maxRedirects: 3,
      persistentConnection: true,
      receiveDataWhenStatusError: true,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Accept-Encoding': 'gzip',
      },
    );

    // Configure HTTP client adapter for connection pooling (non-web only)
    if (!kIsWeb) {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.maxConnectionsPerHost = 10;
          client.connectionTimeout = const Duration(seconds: 10);
          client.idleTimeout = const Duration(seconds: 15);
          return client;
        },
      );
    }
    // Add interceptors (cache interceptor added in _initializeCache)
    _dio.interceptors.clear();
    //  _dio.interceptors.add(LanguageInterceptor());
    _dio.interceptors.add(AuthInterceptor(_appStateService));
    _dio.interceptors.add(RetryInterceptor());
    // _dio.interceptors.add(LoggingInterceptor());
  }

  // GET Request with optional cache configuration
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    Duration? cacheDuration,
    bool forceRefresh = false,
  }) async {
    try {
      Options requestOptions = options ?? Options();

      // Apply custom cache settings if provided
      if (_cacheOptions != null) {
        final customCacheOptions = _cacheOptions!.copyWith(
          policy: forceRefresh ? CachePolicy.refresh : CachePolicy.request,
          maxStale: cacheDuration != null ? Nullable(cacheDuration) : null,
        );
        requestOptions = requestOptions.copyWith(
          extra: {...?requestOptions.extra, ...customCacheOptions.toExtra()},
        );
      }

      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioException(e);
    }
  }

  // POST Request (not cached by default)
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioException(e);
    }
  }

  // PUT Request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioException(e);
    }
  }

  // DELETE Request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioException(e);
    }
  }

  // PATCH Request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw DioExceptionHandler.handleDioException(e);
    }
  }

  // Update base URL
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  // Add authorization token
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Remove authorization token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Update language
  void updateLanguage(String languageCode) {
    _dio.options.headers['lang'] = languageCode;
  }

  // Clear all cached responses
  Future<void> clearCache() async {
    await _cacheStore?.clean();
  }

  // Delete specific cached response by key
  Future<void> deleteCacheByKey(String key) async {
    await _cacheStore?.delete(key);
  }
}

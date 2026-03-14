import 'package:dio/dio.dart';
import '../app_state_service.dart';

class AuthInterceptor extends Interceptor {
  final AppStateService _appStateService;

  AuthInterceptor(this._appStateService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Get the access token from AppStateService
    final accessToken = _appStateService.getAccessToken();
    
    ////print('[AuthInterceptor] 🔐 Token Check:');
    ////print('[AuthInterceptor] - Access Token: ${accessToken != null ? '${accessToken.substring(0, 20)}...' : 'NULL'}');
    ////print('[AuthInterceptor] - Is Logged In: ${_appStateService.isLoggedIn()}');
    
    if (accessToken != null && accessToken.isNotEmpty) {
      // Add Authorization header
      options.headers['Authorization'] = 'Bearer $accessToken';
      ////print('[AuthInterceptor] ✅ Authorization header added to ${options.path}');
    } else {
      ////print('[AuthInterceptor] ⚠️ No token available for ${options.path}');
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token might be expired
    if (err.response?.statusCode == 401) {
      // Token is invalid or expired
      // In a real app, you might want to refresh the token here
      // For now, we'll just pass the error
    }
    
    super.onError(err, handler);
  }
}

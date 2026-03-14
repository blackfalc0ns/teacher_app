import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateService {
  // Non-sensitive keys (SharedPreferences)
  static const String _isOnboardingCompletedKey = 'is_onboarding_completed';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _rememberMeKey = 'remember_me';
  static const String _savedEmailKey = 'saved_email';
  static const String _hasLoggedOutKey = 'has_logged_out';
  static const String _fcmTokenKey = 'fcm_token';
  static const String _userTypeKey = 'user_type';
  static const String _userIdKey = 'user_id';
  static const String _audioVolumeKey = 'audio_volume';

  // Sensitive keys (Secure Storage) ⚠️
  static const String _savedPasswordKey = 'saved_password';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _accessTokenExpiresAtKey = 'access_token_expires_at';
  static const String _refreshTokenExpiresAtKey = 'refresh_token_expires_at';
  static const String _tokenTypeKey = 'token_type';

  // Guest favorites keys (SharedPreferences - not sensitive)
  static const String _guestFavoriteVendorsKey = 'guest_favorite_vendors';
  static const String _guestFavoriteVendorDataKey =
      'guest_favorite_vendor_data';
  static const String _guestFavoritePropertiesKey = 'guest_favorite_properties';
  static const String _guestFavoritePropertyDataKey =
      'guest_favorite_property_data';
  static const String _guestFavoriteProjectsKey = 'guest_favorite_projects';
  static const String _guestFavoriteProjectDataKey =
      'guest_favorite_project_data';

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  // Cache for secure storage values (to avoid async calls)
  String? _cachedAccessToken;
  String? _cachedRefreshToken;
  String? _cachedPassword;

  AppStateService(this._prefs)
    : _secureStorage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );

  /// Initialize cached values from secure storage
  Future<void> init() async {
    _cachedAccessToken = await _secureStorage.read(key: _accessTokenKey);
    _cachedRefreshToken = await _secureStorage.read(key: _refreshTokenKey);
    _cachedPassword = await _secureStorage.read(key: _savedPasswordKey);
  }

  // ==================== Audio Settings ====================

  Future<void> saveAudioVolume(double volume) async {
    await _prefs.setDouble(_audioVolumeKey, volume);
  }

  double getAudioVolume() {
    return _prefs.getDouble(_audioVolumeKey) ?? 0.4; // Default to 40% UI scale
  }

  // ==================== Onboarding State ====================

  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_isOnboardingCompletedKey, completed);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_isOnboardingCompletedKey) ?? false;
  }

  // ==================== Login State ====================

  Future<void> setLoggedIn(bool loggedIn) async {
    await _prefs.setBool(_isLoggedInKey, loggedIn);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  // ==================== Remember Me ====================

  Future<void> setRememberMe(bool remember) async {
    await _prefs.setBool(_rememberMeKey, remember);
  }

  bool getRememberMe() {
    return _prefs.getBool(_rememberMeKey) ?? false;
  }

  // ==================== Credentials (Secure) ====================

  /// Save login credentials securely
  Future<void> saveCredentials(String email, String password) async {
    await _prefs.setString(_savedEmailKey, email);
    await _secureStorage.write(key: _savedPasswordKey, value: password);
    _cachedPassword = password;
  }

  /// Get saved credentials
  Map<String, String?> getSavedCredentials() {
    return {
      'email': _prefs.getString(_savedEmailKey),
      'password': _cachedPassword,
    };
  }

  String? getSavedEmail() {
    return _prefs.getString(_savedEmailKey);
  }

  String? getSavedPassword() {
    return _cachedPassword;
  }

  /// Get password async (if cache is empty)
  Future<String?> getSavedPasswordAsync() async {
    _cachedPassword ??= await _secureStorage.read(key: _savedPasswordKey);
    return _cachedPassword;
  }

  Future<void> clearSavedCredentials() async {
    await _prefs.remove(_savedEmailKey);
    await _secureStorage.delete(key: _savedPasswordKey);
    _cachedPassword = null;
    await _prefs.setBool(_rememberMeKey, false);
  }

  // ==================== Logout State ====================

  Future<void> setHasLoggedOut(bool hasLoggedOut) async {
    await _prefs.setBool(_hasLoggedOutKey, hasLoggedOut);
  }

  bool hasLoggedOut() {
    return _prefs.getBool(_hasLoggedOutKey) ?? false;
  }

  // ==================== FCM Token ====================

  Future<void> saveFcmToken(String fcmToken) async {
    await _prefs.setString(_fcmTokenKey, fcmToken);
  }

  String? getFcmToken() {
    return _prefs.getString(_fcmTokenKey);
  }

  Future<void> clearFcmToken() async {
    await _prefs.remove(_fcmTokenKey);
  }

  // ==================== Token Management (Secure) ====================

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String accessTokenExpiresAt,
    required String refreshTokenExpiresAt,
    String tokenType = 'Bearer',
  }) async {
    // Save tokens securely
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    await _secureStorage.write(
      key: _accessTokenExpiresAtKey,
      value: accessTokenExpiresAt,
    );
    await _secureStorage.write(
      key: _refreshTokenExpiresAtKey,
      value: refreshTokenExpiresAt,
    );
    await _secureStorage.write(key: _tokenTypeKey, value: tokenType);

    // Update cache
    _cachedAccessToken = accessToken;
    _cachedRefreshToken = refreshToken;
  }

  String? getAccessToken() {
    return _cachedAccessToken;
  }

  String? getRefreshToken() {
    return _cachedRefreshToken;
  }

  /// Get access token async (if cache is empty)
  Future<String?> getAccessTokenAsync() async {
    _cachedAccessToken ??= await _secureStorage.read(key: _accessTokenKey);
    return _cachedAccessToken;
  }

  /// Get refresh token async (if cache is empty)
  Future<String?> getRefreshTokenAsync() async {
    _cachedRefreshToken ??= await _secureStorage.read(key: _refreshTokenKey);
    return _cachedRefreshToken;
  }

  Future<String?> getAccessTokenExpiresAt() async {
    return await _secureStorage.read(key: _accessTokenExpiresAtKey);
  }

  Future<String?> getRefreshTokenExpiresAt() async {
    return await _secureStorage.read(key: _refreshTokenExpiresAtKey);
  }

  Future<String?> getTokenType() async {
    return await _secureStorage.read(key: _tokenTypeKey);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _accessTokenExpiresAtKey);
    await _secureStorage.delete(key: _refreshTokenExpiresAtKey);
    await _secureStorage.delete(key: _tokenTypeKey);
    await _prefs.remove(_userTypeKey);
    await _prefs.remove(_userIdKey);

    // Clear cache
    _cachedAccessToken = null;
    _cachedRefreshToken = null;
  }

  // ==================== User Type ====================

  Future<void> saveUserType(String userType) async {
    await _prefs.setString(_userTypeKey, userType);
  }

  String getUserType() {
    return _prefs.getString(_userTypeKey) ?? 'user';
  }

  // ==================== User ID ====================

  Future<void> saveUserId(int userId) async {
    await _prefs.setInt(_userIdKey, userId);
  }

  int? getUserId() {
    return _prefs.getInt(_userIdKey);
  }

  bool isCurrentUser(int ownerId) {
    final currentUserId = getUserId();
    return currentUserId != null && currentUserId == ownerId;
  }

  Future<void> clearUserId() async {
    await _prefs.remove(_userIdKey);
  }

  bool isDeveloperOrBroker() {
    final type = getUserType();
    return type == 'developer' || type == 'broker';
  }

  bool isDeveloper() {
    return getUserType() == 'developer';
  }

  bool isBroker() {
    return getUserType() == 'broker';
  }

  // ==================== Token Expiry ====================

  Future<bool> isAccessTokenExpired() async {
    final expiresAt = await getAccessTokenExpiresAt();
    if (expiresAt == null) return true;

    try {
      final expiryDate = DateTime.parse(expiresAt);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  Future<bool> isRefreshTokenExpired() async {
    final expiresAt = await getRefreshTokenExpiresAt();
    if (expiresAt == null) return true;

    try {
      final expiryDate = DateTime.parse(expiresAt);
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  // ==================== Clear All State ====================

  Future<void> clearAllState() async {
    await _prefs.remove(_isOnboardingCompletedKey);
    await _prefs.remove(_isLoggedInKey);
    await _prefs.remove(_rememberMeKey);
    await _prefs.remove(_savedEmailKey);
    await _prefs.remove(_hasLoggedOutKey);
    await _prefs.remove(_fcmTokenKey);
    await clearSavedCredentials();
    await clearTokens();
  }

  // ==================== Initial Route ====================

  String getInitialRoute() {
    if (!isOnboardingCompleted()) {
      return '/onboarding';
    }
    return '/home';
  }

  // ==================== Login/Logout Handlers ====================

  Future<void> handleSuccessfulLogin({
    required bool rememberMe,
    String? email,
    String? password,
  }) async {
    await setLoggedIn(true);
    await setHasLoggedOut(false);

    if (rememberMe && email != null && password != null) {
      await setRememberMe(true);
      await saveCredentials(email, password);
    } else {
      await clearSavedCredentials();
    }
  }

  Future<void> handleLogout() async {
    await setLoggedIn(false);
    await setHasLoggedOut(true);
    await clearFcmToken();
    await clearTokens();

    if (!getRememberMe()) {
      await clearSavedCredentials();
    }
  }

  Future<void> handleAccountDeletion() async {
    await setLoggedIn(false);
    await setHasLoggedOut(true);
    await clearSavedCredentials();
    await clearTokens();
  }

  // ==================== Guest Vendor Favorites ====================

  List<int> getGuestFavoriteVendorIds() {
    final idsJson = _prefs.getString(_guestFavoriteVendorsKey);
    if (idsJson == null) return [];
    try {
      final List<dynamic> ids = jsonDecode(idsJson);
      return ids.cast<int>();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveGuestFavoriteVendorIds(List<int> ids) async {
    await _prefs.setString(_guestFavoriteVendorsKey, jsonEncode(ids));
  }

  Future<void> addGuestFavoriteVendor(int vendorId) async {
    final ids = getGuestFavoriteVendorIds();
    if (!ids.contains(vendorId)) {
      ids.add(vendorId);
      await saveGuestFavoriteVendorIds(ids);
    }
  }

  Future<void> removeGuestFavoriteVendor(int vendorId) async {
    final ids = getGuestFavoriteVendorIds();
    ids.remove(vendorId);
    await saveGuestFavoriteVendorIds(ids);
  }

  bool isGuestFavoriteVendor(int vendorId) {
    return getGuestFavoriteVendorIds().contains(vendorId);
  }

  Map<int, Map<String, dynamic>> getGuestFavoriteVendorData() {
    final dataJson = _prefs.getString(_guestFavoriteVendorDataKey);
    if (dataJson == null) return {};
    try {
      final Map<String, dynamic> data = jsonDecode(dataJson);
      return data.map(
        (key, value) => MapEntry(int.parse(key), value as Map<String, dynamic>),
      );
    } catch (e) {
      return {};
    }
  }

  Future<void> saveGuestFavoriteVendorData(
    int vendorId,
    Map<String, dynamic> vendorData,
  ) async {
    final data = getGuestFavoriteVendorData();
    data[vendorId] = vendorData;
    final jsonData = data.map((key, value) => MapEntry(key.toString(), value));
    await _prefs.setString(_guestFavoriteVendorDataKey, jsonEncode(jsonData));
  }

  Future<void> removeGuestFavoriteVendorData(int vendorId) async {
    final data = getGuestFavoriteVendorData();
    data.remove(vendorId);
    final jsonData = data.map((key, value) => MapEntry(key.toString(), value));
    await _prefs.setString(_guestFavoriteVendorDataKey, jsonEncode(jsonData));
  }

  Future<void> clearGuestFavoriteVendors() async {
    await _prefs.remove(_guestFavoriteVendorsKey);
    await _prefs.remove(_guestFavoriteVendorDataKey);
  }

  bool hasGuestFavoritesToSync() {
    return getGuestFavoriteVendorIds().isNotEmpty;
  }

  // ==================== Guest Property Favorites ====================

  List<int> getGuestFavoritePropertyIds() {
    final idsJson = _prefs.getString(_guestFavoritePropertiesKey);
    if (idsJson == null) return [];
    try {
      final List<dynamic> ids = jsonDecode(idsJson);
      return ids.cast<int>();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveGuestFavoritePropertyIds(List<int> ids) async {
    await _prefs.setString(_guestFavoritePropertiesKey, jsonEncode(ids));
  }

  Future<void> addGuestFavoriteProperty(int propertyId) async {
    final ids = getGuestFavoritePropertyIds();
    if (!ids.contains(propertyId)) {
      ids.add(propertyId);
      await saveGuestFavoritePropertyIds(ids);
    }
  }

  Future<void> removeGuestFavoriteProperty(int propertyId) async {
    final ids = getGuestFavoritePropertyIds();
    ids.remove(propertyId);
    await saveGuestFavoritePropertyIds(ids);
  }

  bool isGuestFavoriteProperty(int propertyId) {
    return getGuestFavoritePropertyIds().contains(propertyId);
  }

  Map<int, Map<String, dynamic>> getGuestFavoritePropertyData() {
    final dataJson = _prefs.getString(_guestFavoritePropertyDataKey);
    if (dataJson == null) return {};
    try {
      final Map<String, dynamic> data = jsonDecode(dataJson);
      return data.map(
        (key, value) => MapEntry(int.parse(key), value as Map<String, dynamic>),
      );
    } catch (e) {
      return {};
    }
  }

  Future<void> saveGuestFavoritePropertyData(
    int propertyId,
    Map<String, dynamic> propertyData,
  ) async {
    final data = getGuestFavoritePropertyData();
    data[propertyId] = propertyData;
    final jsonData = data.map((key, value) => MapEntry(key.toString(), value));
    await _prefs.setString(_guestFavoritePropertyDataKey, jsonEncode(jsonData));
  }

  Future<void> removeGuestFavoritePropertyData(int propertyId) async {
    final data = getGuestFavoritePropertyData();
    data.remove(propertyId);
    final jsonData = data.map((key, value) => MapEntry(key.toString(), value));
    await _prefs.setString(_guestFavoritePropertyDataKey, jsonEncode(jsonData));
  }

  Future<void> clearGuestFavoriteProperties() async {
    await _prefs.remove(_guestFavoritePropertiesKey);
    await _prefs.remove(_guestFavoritePropertyDataKey);
  }

  bool hasGuestPropertyFavoritesToSync() {
    return getGuestFavoritePropertyIds().isNotEmpty;
  }

  // ==================== Guest Project Favorites ====================

  List<int> getGuestFavoriteProjectIds() {
    final idsJson = _prefs.getString(_guestFavoriteProjectsKey);
    if (idsJson == null) return [];
    try {
      final List<dynamic> ids = jsonDecode(idsJson);
      return ids.cast<int>();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveGuestFavoriteProjectIds(List<int> ids) async {
    await _prefs.setString(_guestFavoriteProjectsKey, jsonEncode(ids));
  }

  Future<void> addGuestFavoriteProject(int projectId) async {
    final ids = getGuestFavoriteProjectIds();
    if (!ids.contains(projectId)) {
      ids.add(projectId);
      await saveGuestFavoriteProjectIds(ids);
    }
  }

  Future<void> removeGuestFavoriteProject(int projectId) async {
    final ids = getGuestFavoriteProjectIds();
    ids.remove(projectId);
    await saveGuestFavoriteProjectIds(ids);
  }

  bool isGuestFavoriteProject(int projectId) {
    return getGuestFavoriteProjectIds().contains(projectId);
  }

  Map<int, Map<String, dynamic>> getGuestFavoriteProjectData() {
    final dataJson = _prefs.getString(_guestFavoriteProjectDataKey);
    if (dataJson == null) return {};
    try {
      final Map<String, dynamic> data = jsonDecode(dataJson);
      return data.map(
        (key, value) => MapEntry(int.parse(key), value as Map<String, dynamic>),
      );
    } catch (e) {
      return {};
    }
  }

  Future<void> saveGuestFavoriteProjectData(
    int projectId,
    Map<String, dynamic> projectData,
  ) async {
    final data = getGuestFavoriteProjectData();
    data[projectId] = projectData;
    final jsonData = data.map((key, value) => MapEntry(key.toString(), value));
    await _prefs.setString(_guestFavoriteProjectDataKey, jsonEncode(jsonData));
  }

  Future<void> removeGuestFavoriteProjectData(int projectId) async {
    final data = getGuestFavoriteProjectData();
    data.remove(projectId);
    final jsonData = data.map((key, value) => MapEntry(key.toString(), value));
    await _prefs.setString(_guestFavoriteProjectDataKey, jsonEncode(jsonData));
  }

  Future<void> clearGuestFavoriteProjects() async {
    await _prefs.remove(_guestFavoriteProjectsKey);
    await _prefs.remove(_guestFavoriteProjectDataKey);
  }

  bool hasGuestProjectFavoritesToSync() {
    return getGuestFavoriteProjectIds().isNotEmpty;
  }
}

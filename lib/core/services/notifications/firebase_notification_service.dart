// import 'dart:async';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../service_locator.dart';
// import '../../network/app_state_service.dart';
// import '../../../features/auth/data/repo/auth_repository.dart';
// import 'models/notification_payload.dart';
// import 'notification_handler.dart';

// /// Top-level function for background message handler
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
//   debugPrint('📱 [Background] Handling background message');
//   debugPrint('Message ID: ${message.messageId}');
//   debugPrint('Title: ${message.notification?.title}');
//   debugPrint('Body: ${message.notification?.body}');
//   debugPrint('Data: ${message.data}');
//   debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
// }

// /// Firebase Cloud Messaging Service
// class FirebaseNotificationService {
//   static final FirebaseNotificationService _instance = FirebaseNotificationService._internal();
//   factory FirebaseNotificationService() => _instance;
//   FirebaseNotificationService._internal();

//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
//   final NotificationHandler _notificationHandler = NotificationHandler();

//   String? _fcmToken;
//   String? get fcmToken => _fcmToken;

//   bool _isInitialized = false;

//   /// Initialize Firebase Messaging and Local Notifications
//   Future<void> initialize() async {
//     if (_isInitialized) {
//       debugPrint('[FCM] Already initialized');
//       return;
//     }

//     try {
//       debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
//       debugPrint('🚀 [FCM] Initializing Firebase Notification Service');
//       debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

//       // Request permission
//       await _requestPermission();

//       // Initialize local notifications
//       await _initializeLocalNotifications();

//       // Get FCM token
//       await _getFCMToken();

//       // Setup message handlers
//       _setupMessageHandlers();

//       // Listen to token refresh
//       _listenToTokenRefresh();

//       _isInitialized = true;
//       debugPrint('✅ [FCM] Initialization completed successfully');
//       debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
//     } catch (e) {
//       debugPrint('❌ [FCM] Initialization failed: $e');
//     }
//   }

//   /// Request notification permission
//   Future<void> _requestPermission() async {
//     debugPrint('[FCM] Requesting notification permission...');
    
//     final settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('✅ [FCM] User granted permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//       debugPrint('⚠️ [FCM] User granted provisional permission');
//     } else {
//       debugPrint('❌ [FCM] User declined or has not accepted permission');
//     }
//   }

//   /// Initialize local notifications
//   Future<void> _initializeLocalNotifications() async {
//     debugPrint('[FCM] Initializing local notifications...');

//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _localNotifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: _onNotificationTapped,
//     );

//     debugPrint('✅ [FCM] Local notifications initialized');
//   }

//   /// Get FCM token
//   Future<void> _getFCMToken() async {
//     try {
//       _fcmToken = await _firebaseMessaging.getToken();
      
//       if (_fcmToken != null) {
//         debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
//         debugPrint('🔑 FCM TOKEN:');
//         debugPrint(_fcmToken);
//         debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        
//         // Save token locally
//         await _saveTokenLocally(_fcmToken!);
        
//         // Send token to backend
//         await _sendTokenToBackend(_fcmToken!);
//       } else {
//         debugPrint('⚠️ [FCM] Failed to get FCM token');
//       }
//     } catch (e) {
//       debugPrint('❌ [FCM] Error getting token: $e');
//     }
//   }

//   /// Listen to token refresh
//   void _listenToTokenRefresh() {
//     _firebaseMessaging.onTokenRefresh.listen((newToken) {
//       debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
//       debugPrint('🔄 [FCM] Token refreshed:');
//       debugPrint(newToken);
//       debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
//       _fcmToken = newToken;
      
//       // Save token locally
//       _saveTokenLocally(newToken);
      
//       // Send new token to backend
//       _sendTokenToBackend(newToken);
//     });
//   }

//   /// Setup message handlers for different states
//   void _setupMessageHandlers() {
//     debugPrint('[FCM] Setting up message handlers...');

//     // 1. Foreground messages (app is open)
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

//     // 2. Background messages (app in background, notification tapped)
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTapped);

//     // 3. Terminated state (app was closed, opened from notification)
//     _checkInitialMessage();

//     debugPrint('✅ [FCM] Message handlers configured');
//   }

//   /// Handle foreground messages (show local notification)
//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
//     debugPrint('📱 [Foreground] New message received');
//     debugPrint('Message ID: ${message.messageId}');
//     debugPrint('Title: ${message.notification?.title}');
//     debugPrint('Body: ${message.notification?.body}');
//     debugPrint('Data: ${message.data}');
//     debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

//     // Show local notification when app is in foreground
//     await _showLocalNotification(message);
//   }

//   /// Handle background message tap
//   Future<void> _handleBackgroundMessageTapped(RemoteMessage message) async {
//     debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
//     debugPrint('👆 [Background] Notification tapped');
//     debugPrint('Message ID: ${message.messageId}');
//     debugPrint('Data: ${message.data}');
//     debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

//     final payload = NotificationPayload.fromMap({
//       'title': message.notification?.title,
//       'body': message.notification?.body,
//       ...message.data,
//     });

//     await _notificationHandler.handleNotification(payload);
//   }

//   /// Check for initial message (terminated state)
//   Future<void> _checkInitialMessage() async {
//     final initialMessage = await _firebaseMessaging.getInitialMessage();
    
//     if (initialMessage != null) {
//       debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
//       debugPrint('🚀 [Terminated] App opened from notification');
//       debugPrint('Message ID: ${initialMessage.messageId}');
//       debugPrint('Data: ${initialMessage.data}');
//       debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

//       final payload = NotificationPayload.fromMap({
//         'title': initialMessage.notification?.title,
//         'body': initialMessage.notification?.body,
//         ...initialMessage.data,
//       });

//       // Delay to ensure app is fully initialized
//       await Future.delayed(const Duration(seconds: 1));
//       await _notificationHandler.handleNotification(payload);
//     }
//   }

//   /// Show local notification
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     // Get image URL from notification or data
//     final String? imageUrl = message.notification?.android?.imageUrl ?? 
//                              message.notification?.apple?.imageUrl ??
//                              message.data['image'] as String?;

//     // Create style with image if available
//     AndroidNotificationDetails androidDetails;
    
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       debugPrint('[FCM] Notification has image: $imageUrl');
      
//       androidDetails = AndroidNotificationDetails(
//         'amtalek_channel',
//         'Amtalek Notifications',
//         channelDescription: 'Notifications for Amtalek app',
//         importance: Importance.high,
//         priority: Priority.high,
//         showWhen: true,
//         icon: '@mipmap/ic_launcher',
//         styleInformation: BigPictureStyleInformation(
//           FilePathAndroidBitmap(imageUrl),
//           largeIcon: FilePathAndroidBitmap(imageUrl),
//           contentTitle: message.notification?.title,
//           summaryText: message.notification?.body,
//           hideExpandedLargeIcon: false,
//         ),
//       );
//     } else {
//       androidDetails = const AndroidNotificationDetails(
//         'amtalek_channel',
//         'Amtalek Notifications',
//         channelDescription: 'Notifications for Amtalek app',
//         importance: Importance.high,
//         priority: Priority.high,
//         showWhen: true,
//         icon: '@mipmap/ic_launcher',
//       );
//     }

//     // iOS details with attachment if image available
//     DarwinNotificationDetails iosDetails;
    
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         attachments: [
//           DarwinNotificationAttachment(imageUrl),
//         ],
//       );
//     } else {
//       iosDetails = const DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       );
//     }

//     final details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotifications.show(
//       message.hashCode,
//       message.notification?.title ?? 'Amtalek',
//       message.notification?.body ?? '',
//       details,
//       payload: message.data.toString(),
//     );

//     debugPrint('✅ [FCM] Local notification shown');
//   }

//   /// Handle local notification tap
//   void _onNotificationTapped(NotificationResponse response) {
//     debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
//     debugPrint('👆 [Local] Notification tapped');
//     debugPrint('Payload: ${response.payload}');
//     debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

//     // Handle notification tap
//     // Parse payload and navigate
//   }

//   /// Subscribe to topic
//   Future<void> subscribeToTopic(String topic) async {
//     try {
//       await _firebaseMessaging.subscribeToTopic(topic);
//       debugPrint('✅ [FCM] Subscribed to topic: $topic');
//     } catch (e) {
//       debugPrint('❌ [FCM] Failed to subscribe to topic: $e');
//     }
//   }

//   /// Unsubscribe from topic
//   Future<void> unsubscribeFromTopic(String topic) async {
//     try {
//       await _firebaseMessaging.unsubscribeFromTopic(topic);
//       debugPrint('✅ [FCM] Unsubscribed from topic: $topic');
//     } catch (e) {
//       debugPrint('❌ [FCM] Failed to unsubscribe from topic: $e');
//     }
//   }

//   /// Delete FCM token
//   Future<void> deleteToken() async {
//     try {
//       await _firebaseMessaging.deleteToken();
//       _fcmToken = null;
//       debugPrint('✅ [FCM] Token deleted');
//     } catch (e) {
//       debugPrint('❌ [FCM] Failed to delete token: $e');
//     }
//   }

//   /// Save token locally in AppStateService
//   Future<void> _saveTokenLocally(String token) async {
//     try {
//       final appStateService = getIt<AppStateService>();
//       await appStateService.saveFcmToken(token);
//       debugPrint('✅ [FCM] Token saved locally');
//     } catch (e) {
//       debugPrint('❌ [FCM] Failed to save token locally: $e');
//     }
//   }

//   /// Send token to backend
//   Future<void> _sendTokenToBackend(String token) async {
//     try {
//       debugPrint('[FCM] 📤 Sending token to backend...');
      
//       final authRepository = getIt<AuthRepository>();
//       final result = await authRepository.setFcmToken(fcmToken: token);
      
//       result.when(
//         success: (_) {
//           debugPrint('✅ [FCM] Token sent to backend successfully');
//         },
//         failure: (exception) {
//           debugPrint('❌ [FCM] Failed to send token to backend: ${exception.message}');
//         },
//       );
//     } catch (e) {
//       debugPrint('❌ [FCM] Error sending token to backend: $e');
//     }
//   }
// }

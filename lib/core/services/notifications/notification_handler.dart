import 'package:flutter/material.dart';
import 'models/notification_payload.dart';
import 'models/notification_type.dart';

/// Handles notification navigation and actions
class NotificationHandler {
  static final NotificationHandler _instance = NotificationHandler._internal();
  factory NotificationHandler() => _instance;
  NotificationHandler._internal();

  GlobalKey<NavigatorState>? navigatorKey;

  /// Initialize with navigator key
  void initialize(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
  }

  /// Handle notification tap
  Future<void> handleNotification(NotificationPayload payload) async {
    if (navigatorKey?.currentContext == null) {
      debugPrint('[NotificationHandler] Navigator context not available');
      return;
    }

    final type = NotificationType.fromString(payload.type);
    final context = navigatorKey!.currentContext!;

    debugPrint('[NotificationHandler] Handling notification: $type');
    debugPrint('[NotificationHandler] Payload: $payload');

    switch (type) {
      case NotificationType.property:
        _handlePropertyNotification(context, payload);
        break;
      case NotificationType.project:
        _handleProjectNotification(context, payload);
        break;
      case NotificationType.chat:
        _handleChatNotification(context, payload);
        break;
      case NotificationType.offer:
        _handleOfferNotification(context, payload);
        break;
      case NotificationType.news:
        _handleNewsNotification(context, payload);
        break;
      case NotificationType.general:
        _handleGeneralNotification(context, payload);
        break;
      case NotificationType.unknown:
        debugPrint('[NotificationHandler] Unknown notification type');
        break;
    }
  }

  void _handlePropertyNotification(BuildContext context, NotificationPayload payload) {
    final propertyId = payload.id ?? payload.data?['property_id'];
    if (propertyId != null) {
      debugPrint('[NotificationHandler] Navigating to property: $propertyId');
      // Navigator.pushNamed(context, '/property-details', arguments: propertyId);
    }
  }

  void _handleProjectNotification(BuildContext context, NotificationPayload payload) {
    final projectId = payload.id ?? payload.data?['project_id'];
    if (projectId != null) {
      debugPrint('[NotificationHandler] Navigating to project: $projectId');
      // Navigator.pushNamed(context, '/project-details', arguments: projectId);
    }
  }

  void _handleChatNotification(BuildContext context, NotificationPayload payload) {
    final chatId = payload.id ?? payload.data?['chat_id'];
    if (chatId != null) {
      debugPrint('[NotificationHandler] Navigating to chat: $chatId');
      // Navigator.pushNamed(context, '/chat', arguments: chatId);
    }
  }

  void _handleOfferNotification(BuildContext context, NotificationPayload payload) {
    debugPrint('[NotificationHandler] Navigating to offers');
    // Navigator.pushNamed(context, '/offers');
  }

  void _handleNewsNotification(BuildContext context, NotificationPayload payload) {
    final newsId = payload.id ?? payload.data?['news_id'];
    if (newsId != null) {
      debugPrint('[NotificationHandler] Navigating to news: $newsId');
      // Navigator.pushNamed(context, '/news-details', arguments: newsId);
    }
  }

  void _handleGeneralNotification(BuildContext context, NotificationPayload payload) {
    debugPrint('[NotificationHandler] General notification - no navigation');
  }
}

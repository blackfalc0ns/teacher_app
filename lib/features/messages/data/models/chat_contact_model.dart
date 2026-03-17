enum MessageStatus { sent, delivered, read, none }

class ChatContactModel {
  final String name;
  final String message;
  final String date;
  final String? imagePath;
  final int unreadCount;
  final MessageStatus status;
  final bool isGroup;

  ChatContactModel({
    required this.name,
    required this.message,
    required this.date,
    this.imagePath,
    this.unreadCount = 0,
    this.status = MessageStatus.none,
    this.isGroup = false,
  });
}

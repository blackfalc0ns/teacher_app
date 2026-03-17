enum MessageType { text, audio }

enum MessageSender { me, other }

class ChatMessageModel {
  final String id;
  final String text; // Also used for audio duration if needed, or left empty
  final MessageType type;
  final MessageSender sender;
  final String date;
  final String time;
  final bool isRead;
  final bool isFirstInGroup;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.type,
    required this.sender,
    required this.date,
    required this.time,
    this.isRead = false,
    this.isFirstInGroup = false,
  });
}

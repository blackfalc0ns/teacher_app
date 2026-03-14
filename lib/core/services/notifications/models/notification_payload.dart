/// Notification payload model
class NotificationPayload {
  final String? title;
  final String? body;
  final String? type;
  final String? id;
  final Map<String, dynamic>? data;

  NotificationPayload({
    this.title,
    this.body,
    this.type,
    this.id,
    this.data,
  });

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    return NotificationPayload(
      title: map['title'] as String?,
      body: map['body'] as String?,
      type: map['type'] as String?,
      id: map['id'] as String?,
      data: map['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'id': id,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'NotificationPayload(title: $title, body: $body, type: $type, id: $id, data: $data)';
  }
}

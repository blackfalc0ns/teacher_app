/// Notification types for routing
enum NotificationType {
  property('property'),
  project('project'),
  chat('chat'),
  offer('offer'),
  news('news'),
  general('general'),
  unknown('unknown');

  final String value;
  const NotificationType(this.value);

  static NotificationType fromString(String? type) {
    if (type == null) return NotificationType.unknown;
    
    return NotificationType.values.firstWhere(
      (e) => e.value == type.toLowerCase(),
      orElse: () => NotificationType.unknown,
    );
  }
}

/// Notification Item Entity (matching Java NotificationItem)
class NotificationItem {
  final int notificationId;
  final int id;
  final String title;
  final String message;
  final String dateAdded;
  final String read; // "yes" or "no"
  final String deepLink;

  const NotificationItem({
    required this.notificationId,
    required this.id,
    required this.title,
    required this.message,
    required this.dateAdded,
    required this.read,
    required this.deepLink,
  });

  bool get isRead => read.toLowerCase() == 'yes';

  NotificationItem copyWith({
    int? notificationId,
    int? id,
    String? title,
    String? message,
    String? dateAdded,
    String? read,
    String? deepLink,
  }) {
    return NotificationItem(
      notificationId: notificationId ?? this.notificationId,
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      dateAdded: dateAdded ?? this.dateAdded,
      read: read ?? this.read,
      deepLink: deepLink ?? this.deepLink,
    );
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: int.tryParse(json['notification_id']?.toString() ??
              json['id']?.toString() ??
              '0') ??
          0,
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? json['body']?.toString() ?? '',
      dateAdded: json['date_added']?.toString() ??
          json['created_at']?.toString() ??
          '',
      read: json['read']?.toString() ?? json['is_read']?.toString() ?? 'no',
      deepLink:
          json['deep_link']?.toString() ?? json['deeplink']?.toString() ?? '',
    );
  }
}

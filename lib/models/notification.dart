/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
class AppNotification {
  final String id;
  final String appId;
  final String content;
  final DateTime receivedDate; // Added field

  AppNotification({
    required this.id,
    required this.appId,
    required this.content,
    required this.receivedDate, // Updated constructor
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'appId': appId,
        'content': content,
        'receivedDate': receivedDate.toIso8601String(),
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      appId: json['appId'],
      content: json['content'],
      receivedDate: DateTime.parse(json['receivedDate']),
    );
  }
}

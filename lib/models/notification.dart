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
}

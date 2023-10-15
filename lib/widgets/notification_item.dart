/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notification.dart';
import '../providers/notification_provider.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;

  const NotificationItem(this.notification, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(notification.content,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: const Icon(Icons.done_all),
          onPressed: () {
            Provider.of<NotificationProvider>(context, listen: false)
                .markAsRead(notification.id, notification.appId);
          },
        ),
      ),
    );
  }
}

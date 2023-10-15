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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(2, 3),
          )
        ],
      ),
      child: ListTile(
        title: Text(notification.content),
        trailing: IconButton(
          icon: const Icon(Icons.mark_email_read),
          onPressed: () {
            Provider.of<NotificationProvider>(context, listen: false)
                .markAsRead(notification.id);
          },
        ),
      ),
    );
  }
}

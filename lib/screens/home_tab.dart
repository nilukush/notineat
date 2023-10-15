/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notification.dart';
import '../providers/notification_provider.dart';
import '../widgets/notification_item.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    var notifications =
        Provider.of<NotificationProvider>(context).notifications;

    // Grouping notifications by appId
    var groupedNotifications = notifications
        .fold<Map<String, List<AppNotification>>>({}, (map, notification) {
      if (!map.containsKey(notification.appId)) {
        map[notification.appId] = [];
      }
      map[notification.appId]?.add(notification);
      return map;
    });

    return ListView.builder(
      itemCount: groupedNotifications.keys.length,
      itemBuilder: (ctx, index) {
        var appId = groupedNotifications.keys.elementAt(index);
        var appNotifications = groupedNotifications[appId];

        return ListTile(
          title: Text(appId),
          subtitle: ListView.builder(
            itemCount: appNotifications?.length,
            itemBuilder: (ctx, i) => NotificationItem(appNotifications![i]),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              Provider.of<NotificationProvider>(context, listen: false)
                  .markAllAsReadForApp(appId);
            },
          ),
        );
      },
    );
  }
}

/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'package:collection/collection.dart';
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
    var groupedNotifications =
        groupBy(notifications, (AppNotification n) => n.appId);

    return ListView.builder(
      itemCount: groupedNotifications.keys.length,
      itemBuilder: (ctx, index) {
        var appId = groupedNotifications.keys.elementAt(index);
        var appNotifications = groupedNotifications[appId];

        return ExpansionTile(
          title: Text(appId),
          children: appNotifications!
              .map((notif) => NotificationItem(notif))
              .toList(),
        );
      },
    );
  }
}

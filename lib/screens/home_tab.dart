/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../widgets/notification_item.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    var notificationsGroupedByApp =
        Provider.of<NotificationProvider>(context).notifications;

    if (notificationsGroupedByApp.isEmpty) {
      return const Center(child: Text('No notifications available.'));
    }

    var sortedAppIds = notificationsGroupedByApp.keys
        .where((appId) => notificationsGroupedByApp[appId]!.isNotEmpty)
        .toList()
      ..sort((a, b) => notificationsGroupedByApp[b]![0]
          .receivedDate
          .compareTo(notificationsGroupedByApp[a]![0].receivedDate));

    return ListView.builder(
      itemCount: sortedAppIds.length,
      itemBuilder: (ctx, index) {
        var appId = sortedAppIds[index];
        var appNotifications = notificationsGroupedByApp[appId];

        return ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            appId,
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
          ),
          children: appNotifications!
              .map((notification) => NotificationItem(notification))
              .toList(),
        );
      },
    );
  }
}

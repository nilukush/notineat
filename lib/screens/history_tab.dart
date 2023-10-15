/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../widgets/notification_item.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    var historyGroupedByApp =
        Provider.of<NotificationProvider>(context).history;

    if (historyGroupedByApp.isEmpty) {
      return const Center(child: Text('No notifications available.'));
    }

    var sortedAppIds = historyGroupedByApp.keys
        .where((appId) => historyGroupedByApp[appId]!.isNotEmpty)
        .toList()
      ..sort((a, b) => historyGroupedByApp[b]![0]
          .receivedDate
          .compareTo(historyGroupedByApp[a]![0].receivedDate));

    return ListView.builder(
      itemCount: sortedAppIds.length,
      itemBuilder: (ctx, index) {
        var appId = sortedAppIds[index];
        var appNotifications = historyGroupedByApp[appId];

        return ExpansionTile(
          initiallyExpanded: true,
          title: Text(
            appId,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors
                        .white70 // Adjusted for better visibility in dark mode
                    : Colors.deepPurple[900]),
          ),
          children: appNotifications!
              .map((notification) => NotificationItem(notification))
              .toList(),
        );
      },
    );
  }
}

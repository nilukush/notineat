/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notineat/models/notification.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    var history = Provider.of<NotificationProvider>(context).history;

    // Grouping by date and then by app
    var groupedHistory = history
        .fold<Map<String, Map<String, List<AppNotification>>>>({},
            (map, notification) {
      var dateKey = DateFormat('yyyy-MM-dd').format(notification.receivedDate);
      if (!map.containsKey(dateKey)) {
        map[dateKey] = {};
      }

      if (!map[dateKey]!.containsKey(notification.appId)) {
        map[dateKey]?[notification.appId] = [];
      }

      map[dateKey]?[notification.appId]?.add(notification);
      return map;
    });

    // Sorting by date
    var sortedDates = groupedHistory.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (ctx, index) {
        var dateKey = sortedDates[index];
        var dayGroup = groupedHistory[dateKey];

        return ExpansionTile(
          backgroundColor:
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          title: Text(dateKey),
          children: dayGroup!.keys
              .map((appName) => ListTile(
                    title: Text(appName),
                    subtitle: Column(
                      children: dayGroup[appName]!
                          .map((notification) => ListTile(
                                title: Text(notification.content),
                              ))
                          .toList(),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}

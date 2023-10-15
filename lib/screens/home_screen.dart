/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../widgets/notification_item.dart';
import 'history_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = Provider.of<NotificationProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NotiNeat'),
          actions: [
            IconButton(
              icon: const Icon(Icons.mark_email_read),
              onPressed: notificationsProvider.clearAllNotifications,
            ),
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: notificationsProvider.toggleDarkMode,
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Notifications'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: notificationsProvider.notifications.length,
              itemBuilder: (ctx, index) {
                final notification = notificationsProvider.notifications[index];
                return NotificationItem(notification);
              },
            ),
            const HistoryTab(),
          ],
        ),
      ),
    );
  }
}

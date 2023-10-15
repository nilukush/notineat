/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import 'history_tab.dart';
import 'home_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _selectedTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('NotiNeat'),
          leading: Image.asset('assets/icon.png', fit: BoxFit.cover),
          // Displaying the app icon
          actions: [
            if (_selectedTabIndex == 0) // Only show for Notifications tab
              IconButton(
                icon: const Icon(Icons.done_all),
                onPressed: () {
                  final provider =
                      Provider.of<NotificationProvider>(context, listen: false);
                  for (var appId in provider.notifications.keys) {
                    provider.markAllAsReadForApp(appId);
                  }
                },
              ),
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () {
                Provider.of<NotificationProvider>(context, listen: false)
                    .toggleDarkMode();
              },
            )
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Notifications'),
              Tab(text: 'History'),
            ],
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),
        ),
        body: const TabBarView(
          children: [
            HomeTab(),
            HistoryTab(),
          ],
        ),
      ),
    );
  }
}

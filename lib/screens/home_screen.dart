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
          backgroundColor: Colors.deepPurple,
          title: Row(
            children: [
              Image.asset('assets/icon.png', height: 32.0, width: 32.0),
              // Adjusted size for better alignment
              const SizedBox(width: 8.0),
              // Some spacing between the icon and the title
              const Text('NotiNeat'),
            ],
          ),
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
            indicatorColor: Colors.purpleAccent,
            // New color for the indicator
            labelColor: Colors.white,
            // Text color for the selected tab
            unselectedLabelColor: Colors.grey[300],
            // Text color for the unselected tab
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

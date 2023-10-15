/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/notification_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => NotificationProvider(),
      child: Consumer<NotificationProvider>(
        builder: (ctx, provider, _) => MaterialApp(
          title: 'NotiNeat',
          theme: ThemeData(
            primaryColor: Colors.blueGrey,
            colorScheme: const ColorScheme.light(
              primary: Colors.blueGrey,
              secondary: Colors.amber,
            ),
          ),
          darkTheme: ThemeData(
            primaryColor: Colors.black,
            colorScheme: const ColorScheme.dark(
              primary: Colors.black,
              secondary: Colors.amber,
            ),
          ),
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

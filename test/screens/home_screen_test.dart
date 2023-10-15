/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
// test/screens/home_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notineat/models/notification.dart';
import 'package:notineat/providers/notification_provider.dart';
import 'package:notineat/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Notification appears in HomeScreen when added',
      (WidgetTester tester) async {
    // Create a NotificationProvider with a mock notification
    final provider = NotificationProvider();
    provider.addNotification(AppNotification(
        id: '1', appId: 'App1', content: 'Test', receivedDate: DateTime.now()));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<NotificationProvider>.value(
        value: provider,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    // Verify if the notification content appears on the screen
    expect(find.text('Test'), findsOneWidget);
  });
}

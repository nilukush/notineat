/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notineat/models/notification.dart';
import 'package:notineat/providers/notification_provider.dart';

void main() {
  late NotificationProvider provider;

  setUp(() {
    provider = NotificationProvider();
  });

  group('NotificationProvider', () {
    test('Adding notification increases count', () {
      final initialCount = provider.notifications.length;
      provider.addNotification(AppNotification(
          id: '1',
          appId: 'App1',
          content: 'Test',
          receivedDate: DateTime.now()));
      expect(provider.notifications.length, initialCount + 1);
    });

    test('Mark notification as read moves it to history', () {
      provider.addNotification(AppNotification(
          id: '3',
          appId: 'App1',
          content: 'Test 3',
          receivedDate: DateTime.now()));
      provider.markAsRead('3');
      expect(provider.history.length, 1);
      expect(provider.notifications.length, 0);
    });

    test('Mark all notifications for an app as read', () {
      provider.addNotification(AppNotification(
          id: '4',
          appId: 'App1',
          content: 'Test 4',
          receivedDate: DateTime.now()));
      provider.addNotification(AppNotification(
          id: '5',
          appId: 'App2',
          content: 'Test 5',
          receivedDate: DateTime.now()));
      provider.markAllAsReadForApp('App1');
      expect(provider.history.length, 1);
      expect(provider.notifications.length, 1);
    });

    test('Clearing all notifications moves them to history', () {
      provider.addNotification(AppNotification(
          id: '5',
          appId: 'App1',
          content: 'Test 5',
          receivedDate: DateTime.now()));
      provider.clearAllNotifications();
      expect(provider.history.length,
          1); // It should match the count of added notifications in this test
      expect(provider.notifications.length, 0);
    });

    test('On receiving a notification, it should be added to the list', () {
      final event = NotificationEvent(
        id: 6,
        packageName: 'AppTest',
        title: 'Test Title',
        text: 'Test Text',
      );
      provider.onNotificationReceived(event);
      expect(provider.notifications.length, 1);
      expect(provider.notifications[0].appId, 'AppTest');
    });
  });
}

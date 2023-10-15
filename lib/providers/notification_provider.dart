/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification.dart';

class NotificationProvider with ChangeNotifier {
  final logger = Logger();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationEvent? _lastNotification;

  NotificationEvent? get lastNotification => _lastNotification;

  final notificationsListener = NotificationsListener();

  final List<AppNotification> _notifications = [];
  final List<AppNotification> _history = [];
  bool _isDarkMode = false;

  List<AppNotification> get notifications => [..._notifications];

  List<AppNotification> get history => [..._history];

  bool get isDarkMode => _isDarkMode;

  // Constructor
  NotificationProvider() {
    _loadDarkModePreference();
    if (Platform.isAndroid) {
      _initNotificationListener();
    } else if (Platform.isIOS) {
      _initLocalNotificationsForiOS();
    }
  }

  init() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void addNotification(AppNotification notif) {
    _notifications.add(notif);
    _notifications.sort((a, b) =>
        b.receivedDate.compareTo(a.receivedDate)); // Sort by received date
    notifyListeners();
  }

  void markAsRead(String id) {
    final notification = _notifications.firstWhere((notif) => notif.id == id);
    _history.add(notification);
    _notifications.remove(notification);
    notifyListeners();
  }

  void markAllAsReadForApp(String appId) {
    final appNotifications =
        _notifications.where((notif) => notif.appId == appId).toList();
    _history.addAll(appNotifications);
    _notifications.removeWhere((notif) => notif.appId == appId);
    notifyListeners();
  }

  void clearAllNotifications() {
    _history.addAll(_notifications);
    _notifications.clear();
    notifyListeners();
  }

  void toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _saveDarkModePreference();
  }

  Future<void> _loadDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> _saveDarkModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  void _initNotificationListener() async {
    // Initializing NotificationsListener
    NotificationsListener.initialize();

    // Define the handler for UI.
    NotificationsListener.receivePort
        ?.listen((event) => onNotificationReceived(event));

    // Check permission and start the service.
    bool? hasPermission = await NotificationsListener.hasPermission;
    if (!hasPermission!) {
      // You can decide what to do here. For instance, you can open permissions settings:
      NotificationsListener.openPermissionSettings();
      return;
    }
    bool? isRunning = await NotificationsListener.isRunning;
    if (!isRunning!) {
      await NotificationsListener.startService();
    }
  }

  void onNotificationReceived(NotificationEvent event) {
    logger.i("Received Notification: ${event.packageName} - ${event.title}");
    if (event.packageName != null &&
        event.title != null &&
        event.text != null) {
      addNotification(AppNotification(
        id: event.id.toString(),
        appId: event.packageName!,
        content: "${event.title!} : ${event.text!}",
        receivedDate: DateTime.now(),
      ));
    }
  }

  Future<void> _initLocalNotificationsForiOS() async {
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}

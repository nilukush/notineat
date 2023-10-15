/*
 * Copyright © [2023] [Nilesh Kumar]. All rights reserved.
 *
 */
import 'dart:convert';
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

  final Map<String, List<AppNotification>> _notificationsGroupedByApp = {};
  final Map<String, List<AppNotification>> _historyGroupedByApp = {};

  bool get isDarkMode => _isDarkMode;

  // Constructor
  NotificationProvider() {
    _loadDarkModePreference();
    _loadNotifications();
    _loadHistoryFromPrefs();

    if (Platform.isAndroid) {
      _initNotificationListener();
    } else if (Platform.isIOS) {
      _initLocalNotificationsForiOS();
    }
  }

  Map<String, List<AppNotification>> get notifications =>
      _notificationsGroupedByApp;

  Map<String, List<AppNotification>> get history => _historyGroupedByApp;

  init() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void addNotification(AppNotification notif) {
    if (!_notificationsGroupedByApp.containsKey(notif.appId)) {
      _notificationsGroupedByApp[notif.appId] = [];
    }
    _notificationsGroupedByApp[notif.appId]!.add(notif);
    _notificationsGroupedByApp[notif.appId]!
        .sort((a, b) => b.receivedDate.compareTo(a.receivedDate));
    _saveNotifications();
    notifyListeners();
  }

  void markAsRead(String id, String appId) {
    final notification = _notificationsGroupedByApp[appId]!
        .firstWhere((notif) => notif.id == id);
    if (!_historyGroupedByApp.containsKey(appId)) {
      _historyGroupedByApp[appId] = [];
    }
    _historyGroupedByApp[appId]!.add(notification);
    _notificationsGroupedByApp[appId]!.remove(notification);
    _saveHistoryToPrefs(); // Save after marking as read
    notifyListeners();
  }

  void markAllAsReadForApp(String appId) {
    if (!_historyGroupedByApp.containsKey(appId)) {
      _historyGroupedByApp[appId] = [];
    }
    _historyGroupedByApp[appId]!.addAll(_notificationsGroupedByApp[appId]!);
    _notificationsGroupedByApp[appId]!.clear();
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

  void _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedNotifications = jsonEncode({
      'notifications': _notificationsGroupedByApp,
      'history': _historyGroupedByApp,
    });
    prefs.setString('allNotifications', encodedNotifications);
  }

  void _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = prefs.getString('allNotifications');
    if (encodedData != null) {
      final Map<String, dynamic> decodedData = jsonDecode(encodedData);
      _notificationsGroupedByApp.clear();
      _historyGroupedByApp.clear();
      if (decodedData['notifications'] != null) {
        (decodedData['notifications'] as Map<String, dynamic>)
            .forEach((key, value) {
          _notificationsGroupedByApp[key] = (value as List)
              .map((data) => AppNotification.fromJson(data))
              .toList();
        });
      }
      if (decodedData['history'] != null) {
        (decodedData['history'] as Map<String, dynamic>).forEach((key, value) {
          _historyGroupedByApp[key] = (value as List)
              .map((data) => AppNotification.fromJson(data))
              .toList();
        });
      }
      notifyListeners();
    }
  }

  Future<void> _saveHistoryToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = history.map((app, notifications) =>
        MapEntry(app, notifications.map((notif) => notif.toJson()).toList()));
    prefs.setString('history', json.encode(historyData));
  }

  Future<void> _loadHistoryFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData =
        json.decode(prefs.getString('history') ?? '{}') as Map<String, dynamic>;
    _historyGroupedByApp.clear();
    historyData.forEach((app, notifications) {
      _historyGroupedByApp[app] = (notifications as List)
          .map((notif) => AppNotification.fromJson(notif))
          .toList();
    });
    notifyListeners();
  }
}

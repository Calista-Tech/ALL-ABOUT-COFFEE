import 'package:flutter/material.dart';

class AppNotification {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color color;
  bool read;

  AppNotification({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.color,
    this.read = false,
  });
}
